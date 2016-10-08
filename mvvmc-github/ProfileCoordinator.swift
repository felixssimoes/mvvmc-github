//
//  Created by Felix Simoes on 27/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class ProfileCoordinator {
    fileprivate let dataStore: DataStore
    fileprivate let authenticationService: AuthenticationService
    fileprivate let authenticationCoordinator: AuthenticationCoordinator
    fileprivate let navigationController: UINavigationController
    fileprivate let navigationCoordinator: NavigationCoordinator
    
    init(navigationController: UINavigationController, dataStore: DataStore, authenticationService: AuthenticationService) {
        self.navigationController = navigationController
        self.dataStore = dataStore
        self.authenticationService = authenticationService
        authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController, dataStore: dataStore, authenticationService: authenticationService)
        navigationCoordinator = NavigationCoordinator(navigationController: navigationController, dataStore: dataStore)
        navigationCoordinator.needsAuthenticationCallback = { [unowned self] in
            self.authenticationService.logout()
            self.authenticationCoordinator.start()
        }
    }
    
    func start() {
        showProfile()
    }

    fileprivate func showProfile() {
        navigationCoordinator.showProfile()
    }
}
