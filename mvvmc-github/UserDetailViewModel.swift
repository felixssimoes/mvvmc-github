//
//  UserDetailViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 16/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class UserDetailViewModel {
    
    private let dataStore: DataStore
    private var user: UserModel?
    private var repositories: [RepositoryModel] = []

    private (set) var isProfile: Bool

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
    
    var didSelectRepositoryCallback: ((repository: RepositoryModel) -> Void)?
    
    func useRepository(at index: Int) {
        guard index < numberOfRepositories else { return }
        didSelectRepositoryCallback?(repository: repositories[index])
    }
    
    // MARK:
    
    func loadData(completion: (result: Result<Void, String>) -> Void) {
        if isProfile {
            loadProfileData(completion: completion)
        } else {
            loadUserData(completion: completion)
        }
    }

    func logout() {
        user = nil
        repositories = []
        unauthorizedCallback?()
    }

    private func loadUserData(completion: (result: Result<Void, String>) -> Void) {
        guard let user = user else { fatalError() }
        dataStore.users().detail(username: user.login) { [weak self] result in
            self?.processUserDetailResult(result, completion: completion)
        }
    }

    private func loadProfileData(completion: (result: Result<Void, String>) -> Void) {
        dataStore.profile().profile { [weak self] result in
            if case .failure(let e) = result, e == .unauthorized {
                self?.unauthorizedCallback?()
                return
            }
            self?.processUserDetailResult(result, completion: completion)
        }
    }

    private func processUserDetailResult(_ result: Result<UserModel, UsersDataError>, completion: (result: Result<Void, String>) -> Void) {
        switch result {
        case .success(let user):
            self.user = user
            dataStore.repositories().repositories(forUser: user) { result in
                switch result {
                case .success(let repositories):
                    self.repositories = repositories
                    completion(result: .success())

                case .failure(_):
                    completion(result: .failure("Error loading user's repositories"))
                }
            }

        case .failure(_):
            completion(result: .failure("Error loading user data"))
        }
    }
}
