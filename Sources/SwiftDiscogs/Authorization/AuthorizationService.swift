//
//  AuthorizationService.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation
import SwiftCore

final class AuthorizationService: Service {

    // MARK: - Private Properties
    
    private var authToken: String?
    private var authVerifier: String?
    private var authSecret: String?
    
    
    
    // MARK: - Properties
    
    let appName: String
    let appVersion: String
    let consumerKey: String
    let consumerSecret: String
    let callbackURL: String
    
    var userAgent: String {
        "\(appName)/\(appVersion)"
    }
    
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
    
    init(appName: String, appVersion: String, consumerKey: String, consumerSecret: String, callbackURL: String) {
        self.appName = appName
        self.appVersion = appVersion
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.callbackURL = callbackURL
        
        if
            let data = UserDefaults.standard.data(for: .accessToken),
            let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) {

            self.accessToken = accessToken
        }
    }
    
    
    
    // MARK: - Functions
    
    func getAuthorizationURL() async throws -> URL {
        try await get("/oauth/request_token", decode: generateAuthorizationURL)
    }
    
    func getAccessToken(verificationURL: URL) async throws {
        if
            let components = URLComponents(url: verificationURL, resolvingAgainstBaseURL: false),
            let authToken = components.queryItems?.first(where: { $0.name == "oauth_token" })?.value,
            let authVerifier = components.queryItems?.first(where: { $0.name == "oauth_verifier" })?.value,
            let authSecret = authSecret {
            
            self.authToken = authToken
            self.authVerifier = authVerifier
            self.authSecret = authSecret
            
            accessToken = try await post("/oauth/access_token", decode: parseAccessTokenResponse)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    
    // MARK: Service Functions
    
    override func prepare(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var headers = [
            #"OAuth oauth_consumer_key="\#(consumerKey)""#,
            #"oauth_nonce="\#(UUID().uuidString)""#,
            #"oauth_signature_method="PLAINTEXT""#,
            #"oauth_timestamp="\#(Int(Date.now.timeIntervalSince1970))""#,
        ]
        
        if let authToken = authToken, let authSecret = authSecret, let authVerifier = authVerifier {
            headers += [
                #"oauth_token="\#(authToken)""#,
                #"oauth_signature="\#(consumerSecret)&\#(authSecret)""#,
                #"oauth_verifier="\#(authVerifier)""#
            ]
        } else {
            headers += [
                #"oauth_signature="\#(consumerSecret)&""#,
                #"oauth_callback="\#(callbackURL)""#
            ]
        }
        request.setValue(headers.joined(separator: ", "), forHTTPHeaderField: "Authorization")
        
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
