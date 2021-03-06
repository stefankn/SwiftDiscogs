//
//  DiscogsClient.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation
import Combine

public final class DiscogsClient {
    
    // MARK: - Constants
    
    private static let accessTokenDefaultsKey = "SwiftDiscogs.AccessToken"
    
    
    
    // MARK: - Private Properties
    
    private let authService: AuthorizationService
    private let service: DiscogsService
    private let appName: String
    private let appVersion: String
    
    private var identity: RIdentity?
    private var accessToken: AccessToken? {
        get { service.accessToken }
        set {
            DispatchQueue.main.async {
                self.service.accessToken = newValue
                self.isAuthorized.send(newValue != nil)
            }
        }
    }
    
    
    
    // MARK: - Properties
    
    public let isAuthorized = CurrentValueSubject<Bool, Never>(false)
    
    
    
    // MARK: - Construction
    
    public init(appName: String, appVersion: String, consumerKey: String, consumerSecret: String, callbackURL: String) {
        self.appName = appName
        self.appVersion = appVersion
        
        let userAgent = "\(appName)/\(appVersion)"
        
        authService = AuthorizationService(
            userAgent: userAgent,
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            callbackURL: callbackURL
        )
        
        service = DiscogsService(userAgent: userAgent, consumerKey: consumerKey, consumerSecret: consumerSecret)
        isAuthorized.send(service.accessToken != nil)
    }
    
    
    
    // MARK: - Functions
    
    public func authorize() async throws -> URL  {
        try await authService.getAuthorizationURL()
    }
    
    public func handleCallback(verificationURL: URL) async throws {
        accessToken = try await authService.getAccessToken(verificationURL: verificationURL)
    }
    
    public func getProfile() async throws -> Profile {
        let identity = try await getIdentity()
        return try await getProfile(username: identity.username)
    }
    
    public func getProfile(username: String) async throws -> Profile {
        try await Profile(service.getProfile(username: username))
    }
    
    public func getCollection(sort: Sorting = .added(.descending), perPage: Int? = nil, nextPage: URL? = nil) async throws -> Pager<CollectionRelease> {
        let identity = try await getIdentity()
        let response = try await service.getCollectionReleases(username: identity.username, sort: sort, perPage: perPage, nextPage: nextPage)
        
        return Pager(response.items.map(CollectionRelease.init), pagination: response.pagination)
    }
    
    public func getWantlist(sort: Sorting = .added(.descending), perPage: Int? = nil, nextPage: URL? = nil) async throws -> Pager<WantlistRelease> {
        let identity = try await getIdentity()
        let response = try await service.getWantlistReleases(username: identity.username, sort: sort, perPage: perPage, nextPage: nextPage)
        
        return Pager(response.wants.map(WantlistRelease.init), pagination: response.pagination)
    }
    
    public func addToWantlist(releaseId: Int) async throws -> WantlistRelease {
        let identity = try await getIdentity()
        return try await WantlistRelease(service.addToWantlist(username: identity.username, releaseId: releaseId))
    }
    
    public func removeFromWantlist(releaseId: Int) async throws {
        let identity = try await getIdentity()
        try await service.removeFromWantlist(username: identity.username, releaseId: releaseId)
    }
    
    public func addToCollection(releaseId: Int, folderId: Int = 1) async throws -> CollectionRelease {
        let identity = try await getIdentity()
        return try await CollectionRelease(service.addToCollection(username: identity.username, releaseId: releaseId, folderId: folderId))
    }
    
    public func removeFromCollection(releaseId: Int, instanceId: Int, folderId: Int = 1) async throws {
        let identity = try await getIdentity()
        try await service.removeFromCollection(username: identity.username, releaseId: releaseId, instanceId: instanceId, folderId: folderId)
    }
    
    public func getRelease(id: Int) async throws -> Release {
        try await Release(service.getRelease(id: id))
    }
    
    public func search(query: String, perPage: Int? = nil) async throws -> Pager<SearchResult> {
        let response = try await service.search(query: query, perPage: perPage)
        return Pager(response.results.map(SearchResult.init), pagination: response.pagination)
    }
    
    public func search(nextPage: URL) async throws -> Pager<SearchResult> {
        let response = try await service.search(nextPage: nextPage)
        return Pager(response.results.map(SearchResult.init), pagination: response.pagination)
    }
    
    
    
    // MARK: - Private Functions
    
    private func getIdentity() async throws -> RIdentity {
        if let identity = identity {
            return identity
        } else {
            let identity = try await service.getIdentity()
            self.identity = identity
            return identity
        }
    }
}
