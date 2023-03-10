//
//  DiscogsService.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation
import SwiftCore

final class DiscogsService: Service {
    
    // MARK: - Properties
    
    let userAgent: String
    let consumerKey: String
    let consumerSecret: String
    
    var accessToken: AccessToken? {
        didSet {
            if
                let accessToken = accessToken,
                let data = try? JSONEncoder().encode(accessToken) {

                UserDefaults.standard.set(data, for: .accessToken)
            } else {
                UserDefaults.standard.remove(for: .accessToken)
            }
        }
    }
    
    
    // MARK: Service Properties
    
    override var baseURL: URL? {
        URL(string: "https://api.discogs.com")
    }
    
    
    
    // MARK: - Construction
    
    init(userAgent: String, consumerKey: String, consumerSecret: String) {
        self.userAgent = userAgent
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret

        if
            let data = UserDefaults.standard.data(for: .accessToken),
            let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) {

            self.accessToken = accessToken
        }
    }
    
    
    
    // MARK: - Functions
    
    func getIdentity() async throws -> Identity {
        try await get("/oauth/identity")
    }
    
    func getProfile(username: String) async throws -> Profile {
        try await get("/users/\(username)")
    }
    
    func getCollectionFolders(username: String) async throws -> [CollectionFolder] {
        try await get("/users/\(username)/collection/folders")
    }
    
    func getCollectionReleases(username: String, sort: Sorting, folderId: Int = 0, perPage: Int? = nil, nextPage: URL? = nil) async throws -> CollectionReleases {
        if let nextPage = nextPage {
            return try await get(nextPage)
        } else {
            var parameters = sort.parameters
            if let perPage = perPage {
                parameters.append(("per_page", perPage))
            }
            
            return try await get("/users/\(username)/collection/folders/\(folderId)/releases", parameters: parameters)
        }
    }
    
    func getWantlistReleases(username: String, sort: Sorting, perPage: Int? = nil, nextPage: URL? = nil) async throws -> WantlistReleases {
        if let nextPage = nextPage {
            return try await get(nextPage)
        } else {
            var parameters = sort.parameters
            if let perPage = perPage {
                parameters.append(("per_page", perPage))
            }
            
            return try await get("/users/\(username)/wants", parameters: parameters)
        }
    }
    
    func getRelease(id: Int) async throws -> Release {
        try await get("/releases/\(id)")
    }
    
    func search(query: String, perPage: Int? = nil) async throws -> SearchResults {
        try await get("/database/search", parameters: [("query", query), ("type", "release")])
    }
    
    func search(nextPage: URL) async throws -> SearchResults {
        try await get(nextPage)
    }
    
    func addToWantlist(username: String, releaseId: Int) async throws -> WantlistRelease {
        try await put("/users/\(username)/wants/\(releaseId)")
    }
    
    func removeFromWantlist(username: String, releaseId: Int) async throws {
        try await delete("/users/\(username)/wants/\(releaseId)")
    }
    
    func addToCollection(username: String, releaseId: Int, folderId: Int) async throws -> CollectionRelease {
        try await post("/users/\(username)/collection/folders/\(folderId)/releases/\(releaseId)")
    }
    
    func removeFromCollection(username: String, releaseId: Int, instanceId: Int, folderId: Int) async throws {
        try await delete("/users/\(username)/collection/folders/\(folderId)/releases/\(releaseId)/instances/\(instanceId)")
    }
    
    
    // MARK: Service Functions
    
    override func prepare(_ request: URLRequest) async throws -> URLRequest {
        guard let accessToken = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = request
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        let headers = [
            #"OAuth oauth_consumer_key="\#(consumerKey)""#,
            #"oauth_nonce="\#(UUID().uuidString)""#,
            #"oauth_signature_method="PLAINTEXT""#,
            #"oauth_timestamp="\#(Int(Date.now.timeIntervalSince1970))""#,
            #"oauth_token="\#(accessToken.token)""#,
            #"oauth_signature="\#(consumerSecret)&\#(accessToken.secret)""#
        ]
        request.setValue(headers.joined(separator: ", "), forHTTPHeaderField: "Authorization")
        
        return request
    }
}
