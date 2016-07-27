//
//  WebStoreRepositoriesTests.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 21/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import XCTest
@testable import mvvmc_github

class WebStoreRepositoriesTests: XCTestCase {
    
    private var api: TestApiClient!
    private var dataProvider: WebStoreRepositoriesDataProvider!
    
    override func setUp() {
        super.setUp()
        api = TestApiClient()
        dataProvider = WebStoreRepositoriesDataProvider(apiClient: api)
    }
    
    func testAllRepositories() {
        let routerExpectation = expectation(description: "correct api router")
        api.callback = { r in
            if case ApiRouter.repositories = r {
                routerExpectation.fulfill()
            }
        }
        
        let reposModelExpectation = expectation(description: "correct repositories count")
        dataProvider.allRepositories { result in
            if case .success(let repos) = result {
                XCTAssertEqual(repos.count, 9)
                reposModelExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testSearchRepositories() {
        let searchQuery = "blah"
        let routerExpectation = expectation(description: "correct api router")
        api.callback = { r in
            if case ApiRouter.repositoriesSearch(let q) = r, q == searchQuery {
                routerExpectation.fulfill()
            }
        }
        
        let reposModelExpectation = expectation(description: "correct repositories model")
        dataProvider.searchRepositories(withText: searchQuery) { result in
            if case .success(let repos) = result {
                XCTAssertEqual(repos.count, 30)
                reposModelExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testUserRepositories() {
        var user: UserModel!
        let usersDataProvider = WebStoreUsersDataProvider(apiClient: api)
        usersDataProvider.detail(username: "") { result in
            switch result {
            case .success(let u): user = u
            case .failure: XCTFail()
            }
        }
        
        let routerExpectation = expectation(description: "correct api route")
        api.callback = { r in
            if case ApiRouter.userRepositories(let username) = r, user.login == username {
                routerExpectation.fulfill()
            }
        }

        let reposModelExpectation = expectation(description: "correct repositories model")
        dataProvider.repositories(forUser: user) { result in
            if case .success(let repos) = result {
                XCTAssertEqual(repos.count, 9)
                reposModelExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
