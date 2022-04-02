//
//  DiscogsService.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation

final class DiscogsService: Service {
    
    // MARK: - Functions
    
    func getIdentity() async throws -> RIdentity {
        try await get("/oauth/identity")
    }
    
    func getProfile(username: String) async throws -> RProfile {
        try await get("/users/\(username)")
    }
    
    func getCollectionReleases(username: String, folderId: Int = 0) async throws -> RCollectionReleases {
        try await get("/users/\(username)/collection/folders/\(folderId)/releases")
    }
    
    func getWantlistReleases(username: String, sort: Sorting, perPage: Int? = nil, nextPage: URL? = nil) async throws -> RWantlistReleases {
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
    
    func getRelease(id: Int) async throws -> RRelease {
        try await get("/releases/\(id)")
    }
    
    func search(barcode: String) async throws -> []
    
    
    // MARK: Service Functions
    
    override func prepareAuthHeaders() throws -> [String] {
        guard let accessToken = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var headers = try super.prepareAuthHeaders()
        
        headers += [
            #"oauth_token="\#(accessToken.token)""#,
            #"oauth_signature="\#(consumerSecret)&\#(accessToken.secret)""#
        ]
        
        return headers
    }
    
    override func prepare(_ request: URLRequest) throws -> URLRequest {
        var request = try super.prepare(request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
