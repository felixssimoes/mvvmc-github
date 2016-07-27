//
//  ProfileAppCoordinator.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 27/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class ProfileAppCoordinator {
    private let dataStore: DataStore
    private let authenticationService: AuthenticationService
    private let navigationController: UINavigationController
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    init(navigationController: UINavigationController, dataStore: DataStore, authenticationService: AuthenticationService) {
        self.navigationController = navigationController
        self.dataStore = dataStore
        self.authenticationService = authenticationService
    }
    
    func start() {
        showProfile()
    }

    private func showProfile() {
        let vc = storyboard.instantiateViewController(withIdentifier: "UserDetail") as! UserDetailViewController
        let vm = UserDetailViewModel(user: nil, dataStore: dataStore, isProfileUser: true)
        vc.viewModel = vm
        navigationController.viewControllers = [vc]
    }
}
