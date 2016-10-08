//
//  TestApiClient.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 17/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
@testable import mvvmc_github

class TestApiClient: ApiClient {
    var callback: ((ApiRouter) -> Void)?
    func execute(_ route: ApiRouter, completion: @escaping ApiClientCompletionHandler) {
        callback?(route)
        completion(.success(route.json))
    }
}


extension ApiRouter {
    var json: AnyObject {
        switch self {
        case .user: return jsonFromFile(withName: "user")!
        case .repositories: return jsonFromFile(withName: "repos")!
        case .userRepositories: return jsonFromFile(withName: "repos")!
        case .repositoriesSearch: return jsonFromFile(withName: "repos_search")!
        case .profile: return jsonFromFile(withName: "user")!
        }
    }
    
    private func jsonFromFile(withName fileName: String) -> AnyObject? {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = NSData(contentsOfFile: filePath) {
            do {
                return try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
            } catch(let error) {
                print("Error loading json from file '\(fileName)' : \(error)")
                return nil
            }
        }
        
        return nil
    }
}
