//
//  LoginViewModel.swift
//  mvvmc-github
//
//  Created by Félix Simões on 26/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class LoginViewModel {
    var username: String?
    var password: String?

    var loginCallback: (() -> Void)?
    var closeCallback: (() -> Void)?

    fileprivate var authenticationService: AuthenticationService

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }

    func login(_ completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        guard let username = username, !username.isEmpty else {
            completion(.failure(.invalidUsername))
            return
        }
        guard let password = password, !password.isEmpty else {
            completion(.failure(.invalidPassword))
            return
        }

        authenticationService.login(username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.loginCallback?()
                completion(.success())

            case .failure(let e):
                completion(.failure(e))
            }
        }
    }

    func cancel() {
        closeCallback?()
    }
}
