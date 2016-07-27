//
//  Repositories.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

protocol RepositoryModel {
    var owner: UserModel { get }
    var id: Int { get }
    var name: String { get }
    var description: String { get }
    var created: Date? { get }
    var language: String? { get }
}

enum RepositoriesError: ErrorProtocol {
    case invalidJson
    case other
}

protocol RepositoriesDataProvider {
    func allRepositories(completion: (result: Result<[RepositoryModel], RepositoriesError>) -> Void)
    func searchRepositories(withText: String, completion: (result: Result<[RepositoryModel], RepositoriesError>) -> Void)
    func repositories(forUser: UserModel, completion: (result: Result<[RepositoryModel], RepositoriesError>) -> Void)
}
