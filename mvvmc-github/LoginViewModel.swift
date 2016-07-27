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

    private var authenticationService: AuthenticationService

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }

    func login(completion: (result: Result<Void, AuthenticationError>) -> Void) {
        guard let username = username, !username.isEmpty else {
            completion(result: .failure(.invalidUsername))
            return
        }
        guard let password = password, !password.isEmpty else {
            completion(result: .failure(.invalidPassword))
            return
        }

        authenticationService.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.loginCallback?()
                completion(result: .success())

            case .failure(let e):
                completion(result: .failure(e))
            }
        }
    }

    func cancel() {
        closeCallback?()
    }
}
