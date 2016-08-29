//
//  Created by Félix Simões on 26/08/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class AppSetup {
    private var searchCoordinator: SearchCoordinator
    private var profileCoordinator: ProfileCoordinator
    private var authentication: AuthenticationService
    private var apiClient: ApiClient
    private var dataStore: DataStore

    init(window: UIWindow) {
        let searchNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [searchNavigationController, profileNavigationController]
        tabbarController.tabBar.items?[0].title = "Search Repositories"
        tabbarController.tabBar.items?[1].title = "Profile"

        window.rootViewController = tabbarController

        authentication = BasicAuthenticationService(defaults: UserDefaults.standard)

        let api = URLSessionApiClient()
        api.autenthication = authentication
        apiClient = api

        dataStore = WebDataStore(apiClient: apiClient, authenticationService: authentication)

        searchCoordinator = SearchCoordinator(navigationController: searchNavigationController, dataStore: dataStore)
        searchCoordinator.start()

        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController, dataStore: dataStore, authenticationService: authentication)
        profileCoordinator.start()
    }
}
