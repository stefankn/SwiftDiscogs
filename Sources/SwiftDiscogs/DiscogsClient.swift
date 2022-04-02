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
            service.accessToken = newValue
            isAuthorized.send(newValue != nil)
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
    
    public func getCollection() async throws -> Pager<CollectionRelease> {
        let identity = try await getIdentity()
        let response = try await service.getCollectionReleases(username: identity.username)
        
        return Pager(response.items.map(CollectionRelease.init), pagination: response.pagination)
    }
    
    public func getWantlist(sort: Sorting = .added(.descending), perPage: Int? = nil, nextPage: URL? = nil) async throws -> Pager<WantlistRelease> {
        let identity = try await getIdentity()
        let response = try await service.getWantlistReleases(username: identity.username, sort: sort, perPage: perPage, nextPage: nextPage)
        
        return Pager(response.wants.map(WantlistRelease.init), pagination: response.pagination)
    }
    
    public func getRelease(id: Int) async throws -> Release {
        try await Release(service.getRelease(id: id))
    }
    
    public func search(barcode: String) async throws -> Pager<SearchResult> {
        let response = try await service.search(barcode: barcode)
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
