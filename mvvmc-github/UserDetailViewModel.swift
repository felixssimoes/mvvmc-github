//
//  UserDetailViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 16/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

enum UserDetailViewModelError: Error {
    case failedLoadingRepositories
    case failedLoadingUser
}

class UserDetailViewModel {
    
    fileprivate let dataStore: DataStore
    fileprivate var user: UserModel?
    fileprivate var repositories: [RepositoryModel] = []

    fileprivate (set) var isProfile: Bool

    var unauthorizedCallback: (() -> Void)?

    init(user: UserModel?, dataStore: DataStore) {
        self.user = user
        self.dataStore = dataStore
        isProfile = (user == nil)
    }
    
    // MARK:

    var username: String {
        return user?.login ?? "-"
    }
    
    var name: String {
        return user?.name ?? username
    }

    var numberOfRepositories: Int {
        return repositories.count
    }
    
    func repository(at index: Int) -> RepositoriesListCellViewModel? {
        guard index < numberOfRepositories else { return nil }
        return RepositoriesListCellViewModel(repository: repositories[index])
    }
    
    var didSelectRepositoryCallback: ((RepositoryModel) -> Void)?
    
    func useRepository(at index: Int) {
        guard index < numberOfRepositories else { return }
        didSelectRepositoryCallback?(repositories[index])
    }
    
    // MARK:
    
    func loadData(_ completion: @escaping (Result<Void, UserDetailViewModelError>) -> Void) {
        if isProfile {
            loadProfileData(completion)
        } else {
            loadUserData(completion)
        }
    }

    func logout() {
        user = nil
        repositories = []
        unauthorizedCallback?()
    }

    fileprivate func loadUserData(_ completion: @escaping (Result<Void, UserDetailViewModelError>) -> Void) {
        guard let user = user else { fatalError() }
        dataStore.users().detail(user.login) { [weak self] result in
            self?.processUserDetailResult(result, completion: completion)
        }
    }

    fileprivate func loadProfileData(_ completion: @escaping (Result<Void, UserDetailViewModelError>) -> Void) {
        dataStore.profile().profile { [weak self] result in
            if case .failure(let e) = result, e == .unauthorized {
                self?.unauthorizedCallback?()
                return
            }
            self?.processUserDetailResult(result, completion: completion)
        }
    }

    fileprivate func processUserDetailResult(_ result: Result<UserModel, UsersDataError>, completion: @escaping (Result<Void, UserDetailViewModelError>) -> Void) {
        switch result {
        case .success(let user):
            self.user = user
            dataStore.repositories().repositories(forUser: user) { [weak self] result in
                switch result {
                case .success(let repositories):
                    self?.repositories = repositories
                    completion(.success())

                case .failure(_):
                    completion(.failure(.failedLoadingRepositories))
                }
            }

        case .failure(_):
            completion(.failure(.failedLoadingUser))
        }
    }
}
