//
//  DiscogsService.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation
import Combine

final class DiscogsService: Service {
    
    // MARK: - Functions
    
    func getIdentity() -> AnyPublisher<RIdentity, Error> {
        get("/oauth/identity")
    }
    
    func getProfile(username: String) -> AnyPublisher<RProfile, Error> {
        get("/users/\(username)")
    }
    
    func getCollectionReleases(username: String, folderId: Int = 0) -> AnyPublisher<RCollectionReleases, Error> {
        get("/users/\(username)/collection/folders/\(folderId)/releases")
    }
    
    func getWantlistReleases(username: String, sort: Sorting, perPage: Int? = nil, nextPage: URL? = nil) -> AnyPublisher<RWantlistReleases, Error> {
        if let nextPage = nextPage {
            return get(nextPage)
        } else {
            var parameters = sort.parameters
            if let perPage = perPage {
                parameters.append(("per_page", perPage))
            }
            
            return get("/users/\(username)/wants", parameters: parameters)
        }
    }
    
    
    // MARK: Service Functions
    
    override func prepareAuthHeaders() throws -> [String] {
        guard let accessToken = accessToken else {
            throw ServiceError.missingCredentials
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
