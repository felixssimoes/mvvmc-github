//
//  WebStoreUsersTests.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 17/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import XCTest
@testable import mvvmc_github

class WebStoreUsersTests: XCTestCase {
    
    fileprivate var api: TestApiClient!
    fileprivate var dataProvider: UsersDataProvider!

    override func setUp() {
        super.setUp()
        api = TestApiClient()
        dataProvider = WebStoreUsersDataProvider(apiClient: api)
    }
    
    func testUserDetail() {
        let username = "username"
        let routerExpectation = expectation(description: "correct api router")
        api.callback = { r in
            if case ApiRouter.user(let u) = r, u == username {
                routerExpectation.fulfill()
            }
        }
        
        let userModelExpectation = expectation(description: "correct user model")
        dataProvider.detail(username) { result in
            if case .success(let u) = result {
                XCTAssertEqual(u.login, "felixssimoes")
                XCTAssertEqual(u.name, "Félix Simões")
                XCTAssertEqual(u.avatarUrl, "https://avatars.githubusercontent.com/u/1503250?v=3")
                XCTAssertEqual(u.url, "https://api.github.com/users/felixssimoes")
                userModelExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
