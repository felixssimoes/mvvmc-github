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

enum ApiError: Error {
    case couldNotParseJSON
    case noData
    case noSuccessStatusCode(statusCode: Int)
    case didNotValidate(errors: [String])
    case unauthorized
    case other(Error)
}

extension ApiError: CustomStringConvertible {
    var description : String {
        switch self {
        case .couldNotParseJSON: return "Could not parse JSON"
        case .noData: return "No Data"
        case .noSuccessStatusCode(let code): return "No success status code: \(code)"
        case .didNotValidate(let e): return "Did not validate (\(e))"
        case .other(let err): return "Other error \(err)"
        case .unauthorized: return "Unauthorized"
        }
    }
}

typealias ApiClientResult = Result<AnyObject, ApiError>
typealias ApiClientCompletionHandler = (ApiClientResult) -> Void

enum ApiRouter {
    case repositories
    case repositoriesSearch(String)
    case user(String)
    case userRepositories(String)
    case profile

    var parameters: [String:AnyObject] {
        switch self {
        case .repositoriesSearch(let query): return ["q" : query as AnyObject]
        default: return [:]
        }
    }
    
    var urlString: String {
        switch self {
        case .repositories: return baseUrlString + "/repositories"
        case .repositoriesSearch: return baseUrlString + "/search/repositories"
        case .user(let username): return baseUrlString + "/users/\(username)"
        case .userRepositories(let username): return baseUrlString + "/users/\(username)/repos"
        case .profile: return baseUrlString + "/user"
        }
    }
    
    fileprivate var baseUrlString: String {
        return "https://api.github.com"
    }
}

protocol ApiClient {
    func execute(_ route: ApiRouter, completion: @escaping ApiClientCompletionHandler)
}

// MARK: - Repositories

extension ApiClient {
    func getAllRepositories(_ completion: @escaping ApiClientCompletionHandler) {
        execute(ApiRouter.repositories, completion: completion)
    }
    
    func repositories(forUser username: String, completion: @escaping ApiClientCompletionHandler) {
        execute(ApiRouter.userRepositories(username), completion: completion)
    }
    
    func searchRepository(_ query: String, completion: @escaping ApiClientCompletionHandler) {
        execute(ApiRouter.repositoriesSearch(query), completion: completion)
    }
}

// MARK: - Users

extension ApiClient {
    func userDetail(withUsername username: String, completion: @escaping ApiClientCompletionHandler) {
        execute(ApiRouter.user(username), completion: completion)
    }

    func user(_ completion: @escaping ApiClientCompletionHandler) {
        execute(ApiRouter.profile, completion: completion)
    }
}
