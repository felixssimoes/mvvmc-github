//
//  Users.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

protocol UserModel {
    var id: Int { get }
    var login: String { get }
    var avatarUrl: String { get }
    
    var url: String { get }
    var name: String? { get }
}

enum UsersDataError: ErrorProtocol {
    case unauthorized
    case other
}

protocol UsersDataProvider {
    func detail(username: String, completion: (result: Result<UserModel, UsersDataError>) -> Void)
}

protocol ProfileDataProvider {
    var isLoggedIn: Bool { get }
    func profile(completion: (result: Result<UserModel, UsersDataError>) -> Void)
}
