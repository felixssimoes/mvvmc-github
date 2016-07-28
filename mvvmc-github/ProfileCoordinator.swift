//
//  Created by Felix Simoes on 27/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class ProfileCoordinator {
    private let dataStore: DataStore
    private let authenticationService: AuthenticationService
    private let authenticationCoordinator: AuthenticationCoordinator
    private let navigationController: UINavigationController
    private let navigationCoordinator: NavigationCoordinator
    
    init(navigationController: UINavigationController, dataStore: DataStore, authenticationService: AuthenticationService) {
        self.navigationController = navigationController
        self.dataStore = dataStore
        self.authenticationService = authenticationService
        authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController, dataStore: dataStore, authenticationService: authenticationService)
        navigationCoordinator = NavigationCoordinator(navigationController: navigationController, dataStore: dataStore)
        navigationCoordinator.needsAuthenticationCallback = { [unowned self] in
            self.authenticationCoordinator.start()
        }
    }
    
    func start() {
        showProfile()
    }

    private func showProfile() {
        navigationCoordinator.showProfile()
    }
}
