//
//  TestAuthenticationService.swift
//  mvvmc-github
//
//  Created by Félix Simões on 28/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
@testable import mvvmc_github

class TestAuthenticationService: AuthenticationService {
    let isLoggedIn = true

    func login(username: String, password: String, completion: (Result<Void, AuthenticationError>) -> Void) {
        completion(.success())
    }

    func logout() {}

    func sign(request: URLRequest) -> URLRequest? {
        return nil
    }
}
