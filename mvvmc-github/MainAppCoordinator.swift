//
//  MainAppCoordinator.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class MainAppCoordinator {
    private struct StoryboardConstants {
        static let name = "Main"
        static let searchIdentifier = "Search"
        static let repositoriesListIdentifier = "RepositoriesList"
        static let repositoryDetailIdentifier = "RepositoryDetail"
        static let userDetailIdentifier = "UserDetail"
    }
    
    private let navigationController: UINavigationController
    private let dataStore: DataStore
    private let storyboard = UIStoryboard(name: StoryboardConstants.name, bundle: nil)
    
    init(navigationController: UINavigationController, dataStore: DataStore) {
        self.navigationController = navigationController
        self.dataStore = dataStore
    }
    
    func start() {
        showSearch()
    }

    private func showSearch() {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.searchIdentifier) as! SearchViewController
        vc.viewModel = SearchViewModel(dataStore: dataStore)
        vc.viewModel.selectRepositoryCallback = { [unowned self] repository in
            self.showDetail(forRepository: repository, shouldShowOwner: true)
        }
        navigationController.viewControllers = [vc]
    }
    
    private func showRepositoriesList() {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.repositoriesListIdentifier) as! RepositoriesListViewController
        vc.viewModel = RepositoriesListViewModel(dataStore: dataStore)
        vc.viewModel.selectRepositoryCallback = { [unowned self] repository in
            self.showDetail(forRepository: repository, shouldShowOwner: true)
        }
        navigationController.viewControllers = [vc]
    }
    
    private func showDetail(forRepository repository: RepositoryModel, shouldShowOwner: Bool) {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.repositoryDetailIdentifier) as! RepositoryDetailViewController
        vc.viewModel = RepositoryDetailViewModel(repository: repository, shouldShowOwner: shouldShowOwner)
        vc.viewModel.didSelectUserCallback = { [unowned self] user in
            self.showDetail(forUser: user)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showDetail(forUser user: UserModel) {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.userDetailIdentifier) as! UserDetailViewController
        vc.viewModel = UserDetailViewModel(user: user, dataStore: dataStore)
        vc.viewModel.didSelectRepositoryCallback = { [unowned self] repository in
            self.showDetail(forRepository: repository, shouldShowOwner: false)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
