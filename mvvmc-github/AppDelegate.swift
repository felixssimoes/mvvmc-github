//
//  AppDelegate.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var app: App!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.main().bounds)
        window?.makeKeyAndVisible()
        
        app = App(window: window!)
        
        return true
    }

}

class App {
    
    private var mainAppCoordinator: MainAppCoordinator
    private var profileAppCoordinator: ProfileAppCoordinator
    private var authentication: AuthenticationService
    private var apiClient: ApiClient
    private var dataStore: DataStore
    
    init(window: UIWindow) {
        let mainNavigationController = UINavigationController()
        let loggedUserNavigationController = UINavigationController()
        
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [mainNavigationController, loggedUserNavigationController]
        
        window.rootViewController = tabbarController
        
        authentication = BasicAuthenticationService()
        
        let myApi = MyApiClient()
        myApi.autenthication = authentication
        apiClient = myApi
        
        dataStore = WebDataStore(apiClient: apiClient, authenticationService: authentication)
        
        mainAppCoordinator = MainAppCoordinator(navigationController: mainNavigationController, dataStore: dataStore)
        mainAppCoordinator.start()
        
        profileAppCoordinator = ProfileAppCoordinator(navigationController: loggedUserNavigationController, dataStore: dataStore, authenticationService: authentication)
        profileAppCoordinator.start()
    }
}
