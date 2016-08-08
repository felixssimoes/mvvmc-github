//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var app: AppSetup!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        app = AppSetup(window: window!)

        window?.makeKeyAndVisible()

        return true
    }

}

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
        
        let myApi = MyApiClient()
        myApi.autenthication = authentication
        apiClient = myApi
        
        dataStore = WebDataStore(apiClient: apiClient, authenticationService: authentication)
        
        searchCoordinator = SearchCoordinator(navigationController: searchNavigationController, dataStore: dataStore)
        searchCoordinator.start()
        
        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController, dataStore: dataStore, authenticationService: authentication)
        profileCoordinator.start()
    }
}
