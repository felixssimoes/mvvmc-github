//
//  WebDataStore.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class WebDataStore {
    fileprivate let apiClient: ApiClient
    fileprivate let authenticationService: AuthenticationService

    init(apiClient: ApiClient, authenticationService: AuthenticationService) {
        self.apiClient = apiClient
        self.authenticationService = authenticationService
    }
}

extension WebDataStore: DataStore {
    func repositories() -> RepositoriesDataProvider {
        return WebStoreRepositoriesDataProvider(apiClient: apiClient)
    }
    
    func users() -> UsersDataProvider {
        return WebStoreUsersDataProvider(apiClient: apiClient)
    }

    func profile() -> ProfileDataProvider {
        return WebProfileDataProvider(apiClient: apiClient, authenticationService: authenticationService)
    }
}
