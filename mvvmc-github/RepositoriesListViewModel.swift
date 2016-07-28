//
//  RepositoriesListViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 12/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class RepositoriesListViewModel {
    private let dataProvider: RepositoriesDataProvider
    private var repositories: [RepositoryModel] = []
    
    var selectRepositoryCallback: ((repository: RepositoryModel) -> Void)?
    
    init(dataStore: DataStore) {
        dataProvider = dataStore.repositories()
    }
    
    func loadData(completion: (result: Result<Void, String>) -> Void) {
        dataProvider.allRepositories { [weak self] result in
            switch result {
            case .failure(_):
                completion(result: .failure("Error loading repositories"))
                
            case .success(let repositories):
                self?.repositories = repositories
                completion(result: .success())
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
    
    func useRepository(at index: Int) {
        guard index < numberOfRepositories else { return }
        selectRepositoryCallback?(repository: repositories[index])
    }
}