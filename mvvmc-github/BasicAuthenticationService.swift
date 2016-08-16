//
//  BasicAuthenticationService.swift
//  mvvmc-github
//
//  Created by Félix Simões on 26/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class BasicAuthenticationService {
    private struct Constants {
        static let usernameKey = "mvvmc-githug.authentication.username"
        static let passwordKey = "mvvmc-githug.authentication.password"
    }

    fileprivate var username: String?
    fileprivate var password: String?

    init() {
        username = UserDefaults.standard.string(forKey: Constants.usernameKey)
        password = UserDefaults.standard.string(forKey: Constants.passwordKey)
    }

    fileprivate func updateUserDefaults() {
        UserDefaults.standard.set(username, forKey: Constants.usernameKey)
        UserDefaults.standard.set(password, forKey: Constants.passwordKey)
        UserDefaults.standard.synchronize()
    }
}

extension BasicAuthenticationService: AuthenticationService {
    
    var isLoggedIn: Bool {
        return !(username?.isEmpty ?? true) && !(password?.isEmpty ?? true)
    }
    
    func login(username: String, password: String, completion: (Result<Void, AuthenticationError>) -> Void) {
        self.username = username
        self.password = password
        updateUserDefaults()
        completion(.success())
    }
    
    func logout() {
        username = nil
        password = nil
        updateUserDefaults()
    }
    
    func sign(request: URLRequest) -> URLRequest? {
        guard let username = username, let password = password else { return nil }
        
        let authString = "\(username):\(password)"
        guard let authData = authString.data(using: String.Encoding.ascii) else { return nil }
        
        let authValue = "Basic \(authData.base64EncodedString())"
        
        var signRequest = request
        signRequest.addValue(authValue, forHTTPHeaderField: "Authorization")
        return signRequest
    }
}
