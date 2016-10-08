//
//  ApiClientTests.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 17/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import XCTest
@testable import mvvmc_github

class ApiClientTests: XCTestCase {
    
    fileprivate var api: TestApiClient!

    override func setUp() {
        super.setUp()
        api = TestApiClient()
    }

    func testGetAllRepositories() {
        api.callback = { r in
            XCTAssertEqual(r.urlString, "https://api.github.com/repositories")
            XCTAssertTrue(r.parameters.isEmpty)
        }
        api.getAllRepositories {_ in}
    }
    
    func testSearchRepositories() {
        let searchText = "searchtext"
        api.callback = { r in
            XCTAssertEqual(r.urlString, "https://api.github.com/search/repositories")
            XCTAssertEqual(r.parameters["q"] as? String, searchText)
        }
        api.searchRepository(searchText) {_ in}
    }
    
    func testUserRepositories() {
        let username = "username"
        api.callback = { r in
            XCTAssertEqual(r.urlString, "https://api.github.com/users/\(username)/repos")
            XCTAssertTrue(r.parameters.isEmpty)
        }
        api.repositories(forUser: username) {_ in}
    }
    
    func testUserDetails() {
        let username = "username"
        api.callback = { r in
            XCTAssertEqual(r.urlString, "https://api.github.com/users/\(username)")
            XCTAssertTrue(r.parameters.isEmpty)
        }
        api.userDetail(withUsername: username) {_ in}
    }
}
