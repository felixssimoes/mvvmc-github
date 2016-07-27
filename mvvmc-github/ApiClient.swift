//
//  ApiClient.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

enum Result<T, E> {
    case success(T)
    case failure(E)
}

enum ApiError: ErrorProtocol {
    case CouldNotParseJSON
    case NoData
    case NoSuccessStatusCode(statusCode: Int)
    case DidNotValidate(errors: [String])
    case Unauthorized
    case Other(NSError)
}

extension ApiError: CustomStringConvertible {
    var description : String {
        switch self {
        case .CouldNotParseJSON: return "Could not parse JSON"
        case .NoData: return "No Data"
        case .NoSuccessStatusCode(let code): return "No success status code: \(code)"
        case .DidNotValidate(let e): return "Did not validate (\(e))"
        case .Other(let err): return "Other error \(err.localizedDescription) \(err.code)"
        case .Unauthorized: return "Unauthorized"
        }
    }
}

typealias ApiClientResult = Result<AnyObject, ApiError>
typealias ApiClientCompletionHandler = (result: ApiClientResult) -> Void

enum ApiRouter {
    case repositories
    case repositoriesSearch(String)
    case user(String)
    case userRepositories(String)
    case loggedUser

    var parameters: [String:AnyObject] {
        switch self {
        case .repositoriesSearch(let query): return ["q" : query]
        default: return [:]
        }
    }
    
    var urlString: String {
        switch self {
        case .repositories: return baseUrlString + "/repositories"
        case .repositoriesSearch: return baseUrlString + "/search/repositories"
        case .user(let username): return baseUrlString + "/users/\(username)"
        case .userRepositories(let username): return baseUrlString + "/users/\(username)/repos"
        case .loggedUser: return baseUrlString + "/user"
        }
    }

    var requiresAuthentication: Bool {
        switch self {
        case .loggedUser: return true
        default: return false
        }
    }
    
    private var baseUrlString: String {
        return "https://api.github.com"
    }
}

protocol ApiClient {
    func execute(route: ApiRouter, completion: ApiClientCompletionHandler)
}

// MARK: - Repositories

extension ApiClient {
    func getAllRepositories(completion: ApiClientCompletionHandler) {
        execute(route: ApiRouter.repositories, completion: completion)
    }
    
    func repositories(forUser username: String, completion: ApiClientCompletionHandler) {
        execute(route: ApiRouter.userRepositories(username), completion: completion)
    }
    
    func searchRepository(query: String, completion: ApiClientCompletionHandler) {
        execute(route: ApiRouter.repositoriesSearch(query), completion: completion)
    }
}

// MARK: - Users

extension ApiClient {
    func userDetail(withUsername username: String, completion: ApiClientCompletionHandler) {
        execute(route: ApiRouter.user(username), completion: completion)
    }

    func user(completion: ApiClientCompletionHandler) {
        execute(route: ApiRouter.loggedUser, completion: completion)
    }
}
