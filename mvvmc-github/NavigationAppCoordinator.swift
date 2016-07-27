//
//  NavigationAppCoordinator.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 27/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class NavigationAppCoordinator {
    private struct StoryboardConstants {
        static let name = "Main"
        static let searchIdentifier = "Search"
        static let repositoriesListIdentifier = "RepositoriesList"
        static let repositoryDetailIdentifier = "RepositoryDetail"
        static let userDetailIdentifier = "UserDetail"
    }
    
    let navigationController: UINavigationController
    let dataStore: DataStore
    let storyboard = UIStoryboard(name: StoryboardConstants.name, bundle: nil)
    
    init(navigationController: UINavigationController, dataStore: DataStore) {
        self.navigationController = navigationController
        self.dataStore = dataStore
    }
    
    func showDetail(forRepository repository: RepositoryModel, shouldShowOwner: Bool) {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.repositoryDetailIdentifier) as! RepositoryDetailViewController
        vc.viewModel = RepositoryDetailViewModel(repository: repository, shouldShowOwner: shouldShowOwner)
        vc.viewModel.didSelectUserCallback = { [unowned self] user in
            self.showDetail(forUser: user)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showDetail(forUser user: UserModel) {
        showUser(user)
    }
    
    func showProfile() {
        showUser(nil)
    }
    
    private func showUser(_ user: UserModel?) {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.userDetailIdentifier) as! UserDetailViewController
        vc.viewModel = UserDetailViewModel(user: user, dataStore: dataStore, isProfileUser: (user == nil))
        vc.viewModel.didSelectRepositoryCallback = { [unowned self] repository in
            self.showDetail(forRepository: repository, shouldShowOwner: false)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
