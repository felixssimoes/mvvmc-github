//
//  SearchViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 17/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class SearchViewModel {
    private let dataProvider: RepositoriesDataProvider
    private var repositories: [RepositoryModel] = []
    
    init(dataStore: DataStore) {
        dataProvider = dataStore.repositories()
    }
    
    func search(text: String, completion: (result: Result<Void, String>) -> Void) {
        dataProvider.searchRepositories(withText: text) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                completion(result: .success())
                
            case .failure(_):
                completion(result: .failure("There was an error while searching."))
            }
        }
    }
    
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    func repository(at index: Int) -> RepositoriesListCellViewModel? {
        guard index < numberOfRepositories else { return nil }
        return RepositoriesListCellViewModel(repository: repositories[index])
    }
    
    //MARK:
    //MARK: Navigation callback
    
    var selectRepositoryCallback: ((repository: RepositoryModel) -> Void)?
    
    func useRepository(at index: Int) {
        guard index < numberOfRepositories else { return }
        selectRepositoryCallback?(repository: repositories[index])
    }
}
