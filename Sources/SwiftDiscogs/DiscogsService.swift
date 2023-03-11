//
//  DiscogsService.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation
import SwiftCore

public final class DiscogsService: Service {
    
    // MARK: - Private Properties
    
    private let authorizationService: AuthorizationService
    private var identity: Identity?
    
    
    
    // MARK: - Properties
    
    public var isAuthorized: Bool {
        authorizationService.accessToken != nil
    }
    
    
    // MARK: Service Properties
    
    public override var baseURL: URL? {
        URL(string: "https://api.discogs.com")
    }
    
    
    
    // MARK: - Construction
    
    public init(appName: String, appVersion: String, consumerKey: String, consumerSecret: String, callbackURL: String) {
        authorizationService = AuthorizationService(
            appName: appName,
            appVersion: appVersion,
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            callbackURL: callbackURL
        )
    }
    
    
    
    // MARK: - Functions
    
    public func authorize() async throws -> URL  {
        try await authorizationService.getAuthorizationURL()
    }
    
    public func handleCallback(verificationURL: URL) async throws {
        try await authorizationService.getAccessToken(verificationURL: verificationURL)
    }

    public func getProfile() async throws -> Profile {
        let identity = try await resolveIdentity()
        return try await get("/users/\(identity.username)")
    }
    
    public func getCollectionFolders() async throws -> [CollectionFolder] {
        let identity = try await resolveIdentity()
        let response: CollectionFolders = try await get("/users/\(identity.username)/collection/folders")
        return response.folders
    }
    
    public func getCollection(sort: Sorting, folder: CollectionFolder? = nil, perPage: Int? = nil, nextPage: URL? = nil) async throws -> Pager<CollectionRelease> {
        let identity = try await resolveIdentity()
        let response: CollectionReleases
        if let nextPage = nextPage {
            response = try await get(nextPage)
        } else {
            var parameters = sort.parameters
            if let perPage = perPage {
                parameters.append(("per_page", perPage))
            }
            
            response = try await get("/users/\(identity.username)/collection/folders/\(folder?.id ?? 0)/releases", parameters: parameters)
        }
        
        return Pager(response.items, pagination: response.pagination)
    }
    
    public func getWantlist(sort: Sorting, perPage: Int? = nil, nextPage: URL? = nil) async throws -> Pager<WantlistRelease> {
        let identity = try await resolveIdentity()
        let response: WantlistReleases
        if let nextPage = nextPage {
            response = try await get(nextPage)
        } else {
            var parameters = sort.parameters
            if let perPage = perPage {
                parameters.append(("per_page", perPage))
            }
            
            response = try await get("/users/\(identity.username)/wants", parameters: parameters)
        }
        
        return Pager(response.wants, pagination: response.pagination)
    }
    
    public func getRelease(id: Int) async throws -> Release {
        try await get("/releases/\(id)")
    }
    
    public func search(query: String, perPage: Int? = nil) async throws -> Pager<SearchResult> {
        let response: SearchResults = try await get("/database/search", parameters: [("query", query), ("type", "release")])
        return Pager(response.results, pagination: response.pagination)
    }
    
    public func search(nextPage: URL) async throws -> Pager<SearchResult> {
        let response: SearchResults = try await get(nextPage)
        return Pager(response.results, pagination: response.pagination)
    }
    
    public func addToWantlist(releaseId: Int) async throws -> WantlistRelease {
        let identity = try await resolveIdentity()
        return try await put("/users/\(identity.username)/wants/\(releaseId)")
    }
    
    public func removeFromWantlist(releaseId: Int) async throws {
        let identity = try await resolveIdentity()
        return try await delete("/users/\(identity.username)/wants/\(releaseId)")
    }
    
    public func addToCollection(releaseId: Int, folderId: Int) async throws -> CollectionRelease {
        let identity = try await resolveIdentity()
        return try await post("/users/\(identity.username)/collection/folders/\(folderId)/releases/\(releaseId)")
    }
    
    public func removeFromCollection(releaseId: Int, instanceId: Int, folderId: Int) async throws {
        let identity = try await resolveIdentity()
        return try await delete("/users/\(identity.username)/collection/folders/\(folderId)/releases/\(releaseId)/instances/\(instanceId)")
    }
    
    
    // MARK: Service Functions
    
    public override func prepare(_ request: URLRequest) async throws -> URLRequest {
        guard let accessToken = authorizationService.accessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = request
        request.setValue(authorizationService.userAgent, forHTTPHeaderField: "User-Agent")

        let headers = [
            #"OAuth oauth_consumer_key="\#(authorizationService.consumerKey)""#,
            #"oauth_nonce="\#(UUID().uuidString)""#,
            #"oauth_signature_method="PLAINTEXT""#,
            #"oauth_timestamp="\#(Int(Date.now.timeIntervalSince1970))""#,
            #"oauth_token="\#(accessToken.token)""#,
            #"oauth_signature="\#(authorizationService.consumerSecret)&\#(accessToken.secret)""#
        ]
        request.setValue(headers.joined(separator: ", "), forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    
    
    // MARK: - Private Functions
    
    private func resolveIdentity() async throws -> Identity {
        if let identity = identity {
            return identity
        } else {
            let identity = try await getIdentity()
            self.identity = identity
            return identity
        }
    }
    
    private func getIdentity() async throws -> Identity {
        try await get("/oauth/identity")
    }
}
