//
//  Service.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation

class Service {
    
    // MARK: - Types
    
    typealias Parameters = [(name: String, value: CustomStringConvertible)]
    
    
    
    // MARK: - Constants
    
    private static let baseURL = URL(string: "https://api.discogs.com")!
    private static let accessTokenDefaultsKey = "SwiftDiscogs.AccessToken"
    
    
    
    // MARK: - Private Properties
    
    private let userAgent: String
    
    
    
    // MARK: - Properties
    
    let consumerKey: String
    let consumerSecret: String
    
    var accessToken: AccessToken? {
        didSet {
            if
                let accessToken = accessToken,
                let data = try? JSONEncoder().encode(accessToken) {
                
                UserDefaults.standard.set(data, forKey: Self.accessTokenDefaultsKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.accessTokenDefaultsKey)
            }
        }
    }
    
    
    
    // MARK: - Construction
    
    init(userAgent: String, consumerKey: String, consumerSecret: String) {
        self.userAgent = userAgent
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        
        if
            let data = UserDefaults.standard.data(forKey: Self.accessTokenDefaultsKey),
            let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) {
            
            self.accessToken = accessToken
        }
    }
    
    
    
    // MARK: - Functions
    
    final func get<Response>(_ path: String, parameters: Parameters? = nil, headers: [String] = [], decode: @escaping (Data) throws -> Response) async throws -> Response {
        try await request(URLRequest(method: .get, url: url(for: path, parameters: parameters)), headers: headers, decode: decode)
    }
    
    final func get<Response: Decodable>(_ path: String, parameters: Parameters? = nil, headers: [String] = []) async throws -> Response {
        try await get(path, parameters: parameters, headers: headers, decode: decode)
    }
    
    final func get<Response: Decodable>(_ url: URL, headers: [String] = []) async throws -> Response {
        try await request(URLRequest(method: .get, url: url), headers: headers, decode: decode)
    }
    
    final func post<Response: Decodable>(_ path: String, parameters: Parameters? = nil, headers: [String] = []) async throws -> Response {
        try await post(path, parameters: parameters, headers: headers, decode: decode)
    }
    
    final func post<Response>(_ path: String, parameters: Parameters? = nil, headers: [String] = [], decode: @escaping (Data) throws -> Response) async throws -> Response {
        try await request(URLRequest(method: .post, url: url(for: path, parameters: parameters)), headers: headers, decode: decode)
    }
    
    final func post(_ path: String, parameters: Parameters? = nil, headers: [String] = []) async throws {
        try await post(path, parameters: parameters, headers: headers, decode: { _ in })
    }
    
    final func put<Response: Decodable>(_ path: String, parameters: Parameters? = nil, headers: [String] = []) async throws -> Response {
        try await put(path, parameters: parameters, headers: headers, decode: decode)
    }
    
    final func put<Response>(_ path: String, parameters: Parameters? = nil, headers: [String] = [], decode: @escaping (Data) throws -> Response) async throws -> Response {
        try await request(URLRequest(method: .put, url: url(for: path, parameters: parameters)), headers: headers, decode: decode)
    }
    
    final func put(_ path: String, parameters: Parameters? = nil, headers: [String] = []) async throws {
        try await put(path, parameters: parameters, headers: headers, decode: { _ in })
    }
    
    final func delete(_ path: String, parameters: Parameters? = nil, headers: [String] = []) async throws {
        try await request(URLRequest(method: .delete, url: url(for: path, parameters: parameters)), headers: headers, decode: { _ in })
    }
    
    func prepareAuthHeaders() throws -> [String] {
        [
            #"OAuth oauth_consumer_key="\#(consumerKey)""#,
            #"oauth_nonce="\#(UUID().uuidString)""#,
            #"oauth_signature_method="PLAINTEXT""#,
            #"oauth_timestamp="\#(Int(Date.now.timeIntervalSince1970))""#
        ]
    }
    
    func prepare(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
    
    
    
    // MARK: - Private Functions
    
    private func request<Response: Decodable>(_ request: URLRequest, headers: [String]) async throws -> Response {
        try await self.request(request, headers: headers, decode: decode)
    }
    
    private func request<Response>(_ request: URLRequest, headers: [String], decode: @escaping (Data) throws -> Response) async throws -> Response {
        let authHeaders = try prepareAuthHeaders()
        var request = request
        request.setValue((authHeaders + headers).joined(separator: ", "), forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse, response.status.isSuccess {
            return try decode(data)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    private func decode<Response: Decodable>(_ data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
    
    private func url(for path: String, parameters: Parameters?) throws -> URL {
        if let url = URL(string: path, relativeTo: Self.baseURL) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if let parameters = parameters, !parameters.isEmpty {
                let queryItems = (components?.queryItems ?? []) + parameters.map{ URLQueryItem(name: $0.name, value: $0.value.description) }
                components?.queryItems = queryItems
            }
            
            if let url = components?.url {
                return url
            }
        }
        
        throw URLError(.badURL)
    }
}
