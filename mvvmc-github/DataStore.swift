//
//  DataStore.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

protocol DataStore {
    func repositories() -> RepositoriesDataProvider
    func users() -> UsersDataProvider
    func profile() -> ProfileDataProvider
}
