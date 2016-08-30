//
//  RepositoriesListViewController.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation
import UIKit

extension RepositoriesListViewModelError: CustomStringConvertible {
    var description: String {
        return "Error loading repositories"
    }
}


class RepositoriesListViewController: UITableViewController {
    
    private struct Constants {
        static let cellIdentifier = "RepositoryCell"
    }
    
    var viewModel: RepositoriesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadData { [weak self] result in
            switch result {
            case .success: self?.tableView.reloadData()
            case .failure(let error): print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRepositories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        if let cellViewModel = viewModel.repository(at: indexPath.row) {
            cell.textLabel?.text = cellViewModel.title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.useRepository(at: indexPath.row)
    }
}
