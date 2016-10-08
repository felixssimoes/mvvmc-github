//
//  BasicAuthenticationService.swift
//  mvvmc-github
//
//  Created by Félix Simões on 26/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class BasicAuthenticationService {
    fileprivate struct Constants {
        static let usernameKey = "mvvmc-githug.authentication.username"
        static let passwordKey = "mvvmc-githug.authentication.password"
    }

    fileprivate var username: String?
    fileprivate var password: String?

    fileprivate let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        username = defaults.string(forKey: Constants.usernameKey)
        password = defaults.string(forKey: Constants.passwordKey)
    }

    fileprivate func updateUserDefaults() {
        defaults.set(username, forKey: Constants.usernameKey)
        defaults.set(password, forKey: Constants.passwordKey)
        defaults.synchronize()
    }
}

extension BasicAuthenticationService: AuthenticationService {
    
    var isLoggedIn: Bool {
        return !(username?.isEmpty ?? true) && !(password?.isEmpty ?? true)
    }
    
    func login(_ username: String, password: String, completion: (Result<Void, AuthenticationError>) -> Void) {
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
    
    func sign(_ request: URLRequest) -> URLRequest? {
        guard let username = username, let password = password else { return nil }
        
        let authString = "\(username):\(password)"
        guard let authData = authString.data(using: String.Encoding.ascii) else { return nil }
        
        let authValue = "Basic \(authData.base64EncodedString())"
        
        var signRequest = request
        signRequest.addValue(authValue, forHTTPHeaderField: "Authorization")
        return signRequest
    }
}
