//
//  WebStoreUser.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

struct WebStoreUser: UserModel {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    let name: String?
    
    static func user(fromJson json: AnyObject) -> UserModel? {
        guard let id = json["id"] as? Int else { return nil }
        guard let login = json["login"] as? String else { return nil }
        guard let avatarUrl = json["avatar_url"] as? String else { return nil }
        guard let url = json["url"] as? String else { return nil }
        let name = json["name"] as? String
        
        return WebStoreUser(id: id, login: login, avatarUrl: avatarUrl, url: url, name: name)
    }
}

class WebStoreUsersDataProvider: UsersDataProvider {
    
    private let apiClient: ApiClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func detail(username: String, completion: (result: Result<UserModel, UsersDataError>) -> Void) {
        apiClient.userDetail(withUsername: username) { result in
            if case .success(let json) = result, let user = WebStoreUser.user(fromJson: json) {
                completion(result: .success(user))
            } else {
                completion(result: .failure(.other))
            }
        }
    }
}

class WebProfileDataProvider: ProfileDataProvider {

    private let apiClient: ApiClient
    private let authenticationService: AuthenticationService

    init(apiClient: ApiClient, authenticationService: AuthenticationService) {
        self.apiClient = apiClient
        self.authenticationService = authenticationService
    }

    var isLoggedIn: Bool { return authenticationService.isLoggedIn }
    
    func profile(completion: (result: Result<UserModel, UsersDataError>) -> Void) {
        apiClient.user { result in
            if case .success(let json) = result, let user = WebStoreUser.user(fromJson: json) {
                completion(result: .success(user))
            } else if case .failure(let e) = result , case .Unauthorized = e {
                completion(result: .failure(.unauthorized))
            } else {
                completion(result: .failure(.other))
            }
        }
    }
}
