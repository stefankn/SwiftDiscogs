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
    
    public func authorize() -> AnyPublisher<URL, Error>  {
        authService
            .getAuthorizationURL()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func handleCallback(verificationURL: URL) -> AnyPublisher<Void, Error> {
        authService
            .getAccessToken(verificationURL: verificationURL)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in
                self?.accessToken = $0
            })
            .map{ _ in () }
            .eraseToAnyPublisher()
    }
    
    public func getProfile() -> AnyPublisher<Profile, Error> {
        getIdentity()
            .flatMap{ self.getProfile(username: $0.username) }.eraseToAnyPublisher()
    }
    
    public func getProfile(username: String) -> AnyPublisher<Profile, Error> {
        service.getProfile(username: username).map(Profile.init).eraseToAnyPublisher()
    }
    
    public func getCollection() -> AnyPublisher<Pager<CollectionRelease>, Error> {
        getIdentity()
            .flatMap{ self.service.getCollectionReleases(username: $0.username) }
            .map{ Pager($0.items.map(CollectionRelease.init), pagination: $0.pagination) }
            .eraseToAnyPublisher()
    }
    
    public func getWantlist(sort: Sorting = .added(.descending), perPage: Int? = nil, nextPage: URL? = nil) -> AnyPublisher<Pager<WantlistRelease>, Error> {
        getIdentity()
            .flatMap{ self.service.getWantlistReleases(username: $0.username, sort: sort, perPage: perPage, nextPage: nextPage) }
            .map{ Pager($0.wants.map(WantlistRelease.init), pagination: $0.pagination) }
            .eraseToAnyPublisher()
    }
    
    
    
    // MARK: - Private Functions
    
    private func getIdentity() -> AnyPublisher<RIdentity, Error> {
        if let identity = identity {
            return .just(identity)
        } else {
            return service
                .getIdentity()
                .handleEvents(receiveOutput: { self.identity = $0 })
                .eraseToAnyPublisher()
        }
    }
}
