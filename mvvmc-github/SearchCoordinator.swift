//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

class SearchCoordinator {
    fileprivate struct StoryboardConstants {
        static let name = "Main"
        static let searchIdentifier = "Search"
    }
    
    fileprivate let navigationController: UINavigationController
    fileprivate let dataStore: DataStore
    fileprivate let navigationCoordinator: NavigationCoordinator
    fileprivate let storyboard = UIStoryboard(name: StoryboardConstants.name, bundle: nil)
    
    init(navigationController: UINavigationController, dataStore: DataStore) {
        self.navigationController = navigationController
        self.dataStore = dataStore

        navigationCoordinator = NavigationCoordinator(navigationController: navigationController, dataStore: dataStore)
    }
    
    func start() {
        showSearch()
    }

    fileprivate func showSearch() {
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.searchIdentifier) as! SearchViewController
        vc.viewModel = SearchViewModel(dataStore: dataStore)
        vc.viewModel.selectRepositoryCallback = { [unowned self] repository in
            self.navigationCoordinator.showDetail(forRepository: repository, shouldShowOwner: true)
        }
        navigationController.viewControllers = [vc]
    }
}
