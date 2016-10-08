//
//  RepositoriesListViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 12/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

enum RepositoriesListViewModelError: Error {
    case failedLoadRespositories
}

class RepositoriesListViewModel {
    fileprivate let dataProvider: RepositoriesDataProvider
    fileprivate var repositories: [RepositoryModel] = []
    
    var selectRepositoryCallback: ((RepositoryModel) -> Void)?
    
    init(dataStore: DataStore) {
        dataProvider = dataStore.repositories()
    }
    
    func loadData(_ completion: @escaping (Result<Void, RepositoriesListViewModelError>) -> Void) {
        dataProvider.allRepositories { [weak self] result in
            switch result {
            case .failure(_):
                completion(.failure(.failedLoadRespositories))
                
            case .success(let repositories):
                self?.repositories = repositories
                completion(.success())
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
        selectRepositoryCallback?(repositories[index])
    }
}
