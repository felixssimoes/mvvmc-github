//
//  SearchViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 17/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

enum SearchViewModelError: Error {
    case searchFailed
}

class SearchViewModel {
    private let dataProvider: RepositoriesDataProvider
    private var repositories: [RepositoryModel] = []
    
    init(dataStore: DataStore) {
        dataProvider = dataStore.repositories()
    }
    
    func search(text: String, completion: @escaping (Result<Void, SearchViewModelError>) -> Void) {
        dataProvider.searchRepositories(withText: text) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                completion(.success())
                
            case .failure(_):
                completion(.failure(.searchFailed))
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
    
    var selectRepositoryCallback: ((RepositoryModel) -> Void)?
    
    func useRepository(at index: Int) {
        guard index < numberOfRepositories else { return }
        selectRepositoryCallback?(repositories[index])
    }
}
