//
//  WebStoreRepositories.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

struct WebStoreRepository: RepositoryModel {
    let owner: UserModel
    let id: Int
    let name: String
    let description: String
    let created: Date?
    let language: String?
    
    static func repository(fromJson json: AnyObject) -> RepositoryModel? {
        guard let ownerJson = json["owner"] as? [String : AnyObject] else { return nil }
        guard let owner = WebStoreUser.user(fromJson: ownerJson as AnyObject) else { return nil }
        guard let id = json["id"] as? Int else { return nil }
        guard let name = json["name"] as? String else { return nil }
        guard let description = json["description"] as? String else { return nil }
        
        let language = json["language"] as? String
        
        let createdDate: Date? = {
            guard let dateString = json["created_at"] as? String else { return nil }
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: dateString)
        }()
        
        return WebStoreRepository(owner: owner,
                                  id: id,
                                  name: name,
                                  description: description,
                                  created: createdDate,
                                  language: language)
    }
}

class WebStoreRepositoriesDataProvider {
    typealias RepositoriesCompletion = (Result<[RepositoryModel], RepositoriesError>) -> Void

    fileprivate let apiClient: ApiClient
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
}

extension WebStoreRepositoriesDataProvider: RepositoriesDataProvider {

    func allRepositories(_ completion: @escaping RepositoriesCompletion) {
        apiClient.getAllRepositories { (result) in
            switch result {
            case .success(let json):
                self.processJson(json, completion: completion)

            case .failure:
                completion(.failure(.other))
            }
        }
    }
    
    func searchRepositories(withText query: String, completion: @escaping RepositoriesCompletion) {
        apiClient.searchRepository(query) { result in
            switch result {
            case .success(let json):
                guard let reposJson = json["items"] as? [AnyObject] else {
                    completion(.failure(.invalidJson))
                    return
                }
                self.processJson(reposJson as AnyObject, completion: completion)

            case .failure:
                completion(.failure(.other))
            }
        }
    }
    
    func repositories(forUser user: UserModel, completion: @escaping RepositoriesCompletion) {
        apiClient.repositories(forUser: user.login) { result in
            switch result {
            case .success(let json):
                self.processJson(json, completion: completion)

            case .failure:
                completion(.failure(.other))
            }
        }
    }

    fileprivate func processJson(_ json: AnyObject, completion: @escaping RepositoriesCompletion) {
        if let reposJson = json as? [AnyObject] {
            completion(.success(reposJson.flatMap(WebStoreRepository.repository)))
        } else {
            completion(.failure(.invalidJson))
        }
    }
}
