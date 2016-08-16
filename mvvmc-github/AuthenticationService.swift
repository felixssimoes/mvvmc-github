//
//  AuthenticationService.swift
//  mvvmc-github
//
//  Created by Félix Simões on 26/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

enum AuthenticationError {
    case invalidUsername
    case invalidPassword
    case invalidCredentials
}

protocol AuthenticationService {
    var isLoggedIn: Bool { get }

    func login(username: String, password: String, completion: (Result<Void, AuthenticationError>) -> Void)
    func logout()
    
    func sign(request: URLRequest) -> URLRequest?
}
