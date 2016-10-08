//
//  AuthenticationCoordinator.swift
//  mvvmc-github
//
//  Created by Félix Simões on 28/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationCoordinator {
    fileprivate struct StoryboardConstants {
        static let name = "Authentication"
        static let loginIdentifier = "Login"
    }

    fileprivate let storyboard = UIStoryboard(name: StoryboardConstants.name, bundle: nil)
    fileprivate let anchestorNavigationController: UINavigationController
    fileprivate let authenticationService: AuthenticationService
    fileprivate let dataStore: DataStore

    var loginFinishedCallback: (() -> Void)?

    init(navigationController: UINavigationController, dataStore: DataStore, authenticationService: AuthenticationService) {
        anchestorNavigationController = navigationController
        self.authenticationService = authenticationService
        self.dataStore = dataStore
    }

    func start() {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.loginIdentifier) as! LoginViewController
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .currentContext

        vc.viewModel = LoginViewModel(authenticationService: authenticationService)
        vc.viewModel.loginCallback = { [unowned self] in
            nc.dismiss(animated: true, completion: nil)
            self.loginFinishedCallback?()
        }
        vc.viewModel.closeCallback = {}

        anchestorNavigationController.present(nc, animated: true, completion: nil)
    }
}
