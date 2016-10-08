//
//  RepositoryDetailViewModel.swift
//  mvvcc-demo
//
//  Created by Félix Simões on 19/06/16.
//  Copyright © 2016 Felix Simoes. All rights reserved.
//

import Foundation

class RepositoryDetailViewModel {
    
    fileprivate let repository: RepositoryModel
    
    var name: String
    var description: String
    var language: String?
    var createdDate: String?
    
    var userName: String
    
    let shouldShowOwner: Bool
    
    init(repository: RepositoryModel, shouldShowOwner: Bool = true) {
        self.shouldShowOwner = shouldShowOwner
        self.repository = repository
        self.name = repository.name
        self.description = repository.description
        self.language = repository.language
        if let date = repository.created {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.createdDate = formatter.string(from: date)
        }
        
        self.userName = repository.owner.login
    }
    
    var didSelectUserCallback: ((UserModel) -> Void)?
    
    func selectUser() {
        didSelectUserCallback?(repository.owner)
    }
}
