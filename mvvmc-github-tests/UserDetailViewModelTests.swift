//
//  UserDetailViewModelTests.swift
//  mvvmc-github
//
//  Created by Félix Simões on 28/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import XCTest
@testable import mvvmc_github

class UserDetailViewModelTests: XCTestCase {

    fileprivate var api: TestApiClient!
    fileprivate var dataStore: DataStore!

    override func setUp() {
        super.setUp()
        api = TestApiClient()
        dataStore = WebDataStore(apiClient: api, authenticationService: TestAuthenticationService())
    }
    
    func testProfile() {
        let vm = UserDetailViewModel(user: nil, dataStore: dataStore)
        XCTAssertTrue(vm.isProfile)

        vm.loadData {_ in}
        XCTAssertEqual(vm.username, "felixssimoes")
        XCTAssertEqual(vm.name, "Félix Simões")
    }
    
}
