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
    func execute(route: ApiRouter, completion: ApiClientCompletionHandler) {
        callback?(route)
        completion(.success(route.json))
    }
}


extension ApiRouter {
    var json: AnyObject {
        switch self {
        case .user: return jsonFromFile(fileName: "user")!
        case .repositories: return jsonFromFile(fileName: "repos")!
        case .userRepositories: return jsonFromFile(fileName: "repos")!
        case .repositoriesSearch: return jsonFromFile(fileName: "repos_search")!
        case .profile: return jsonFromFile(fileName: "user")!
        }
    }
    
    private func jsonFromFile(fileName: String) -> AnyObject? {
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
