//
//  AuthorizationService.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation

final class AuthorizationService: Service {

    // MARK: - Private Properties
    
    private let callbackURL: String
    private var authSecret: String?
    
    
    
    // MARK: - Construction
    
    init(userAgent: String, consumerKey: String, consumerSecret: String, callbackURL: String) {
        self.callbackURL = callbackURL
        
        super.init(userAgent: userAgent, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    
    
    // MARK: - Functions
    
    func getAuthorizationURL() async throws -> URL {
        let headers = [
            #"oauth_signature="\#(consumerSecret)&""#,
            #"oauth_callback="\#(callbackURL)""#
        ]
        
        return try await get("/oauth/request_token", headers: headers, decode: generateAuthorizationURL)
    }
    
    func getAccessToken(verificationURL: URL) async throws -> AccessToken {
        if
            let components = URLComponents(url: verificationURL, resolvingAgainstBaseURL: false),
            let authToken = components.queryItems?.first(where: { $0.name == "oauth_token" })?.value,
            let authVerifier = components.queryItems?.first(where: { $0.name == "oauth_verifier" })?.value,
            let authSecret = authSecret {
            
            let headers = [
                #"oauth_token="\#(authToken)""#,
                #"oauth_signature="\#(consumerSecret)&\#(authSecret)""#,
                #"oauth_verifier="\#(authVerifier)""#
            ]
            
            return try await post("/oauth/access_token", headers: headers, decode: parseAccessTokenResponse)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    
    // MARK: Service Functions
    
    override func prepare(_ request: URLRequest) throws -> URLRequest {
        var request = try super.prepare(request)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    
    // MARK: - Private Functions
    
    private func generateAuthorizationURL(from response: Data) throws -> URL {
        if
            let response = String(data: response, encoding: .utf8),
            let components = URLComponents(string: "?\(response)"),
            let authToken = components.queryItems?.first(where: { $0.name == "oauth_token" })?.value,
            let authSecret = components.queryItems?.first(where: { $0.name == "oauth_token_secret"})?.value,
            let url = URL(string: "https://discogs.com/oauth/authorize?oauth_token=\(authToken)") {

            self.authSecret = authSecret
            return url
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    private func parseAccessTokenResponse(_ response: Data) throws -> AccessToken {
        if
            let response = String(data: response, encoding: .utf8),
            let components = URLComponents(string: "?\(response)"),
            let accessToken = components.queryItems?.first(where: { $0.name == "oauth_token" })?.value,
            let accessTokenSecret = components.queryItems?.first(where: { $0.name == "oauth_token_secret" })?.value {

            return AccessToken(token: accessToken, secret: accessTokenSecret)
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
