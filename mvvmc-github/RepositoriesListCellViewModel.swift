//
//  RepositoriesListCellViewModel.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 12/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class RepositoriesListCellViewModel {
    let title: String
    
    init(repository: RepositoryModel) {
        title = repository.name
    }
}
