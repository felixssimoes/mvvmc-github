//
//  Created by Félix Simões on 26/08/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class AppSetup {
    fileprivate var searchCoordinator: SearchCoordinator
    fileprivate var profileCoordinator: ProfileCoordinator
    fileprivate var authentication: AuthenticationService
    fileprivate var apiClient: ApiClient
    fileprivate var dataStore: DataStore

    init(window: UIWindow) {
        let searchNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [searchNavigationController, profileNavigationController]
        tabbarController.tabBar.items?[0].title = "Search Repositories"
        tabbarController.tabBar.items?[1].title = "Profile"

        window.rootViewController = tabbarController

        authentication = BasicAuthenticationService(defaults: UserDefaults.standard)
        apiClient = URLSessionApiClient(authentication: authentication)

        dataStore = WebDataStore(apiClient: apiClient, authenticationService: authentication)

        searchCoordinator = SearchCoordinator(navigationController: searchNavigationController, dataStore: dataStore)
        searchCoordinator.start()

        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController, dataStore: dataStore, authenticationService: authentication)
        profileCoordinator.start()
    }
}
