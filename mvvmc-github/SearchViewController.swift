//
//  SearchViewController.swift
//  mvvmc-github
//
//  Created by Félix Simões on 17/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    private struct Constants {
        static let cellIdentifier = "RepositoryCell"
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repository search"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRepositories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        if let cellViewModel = viewModel.repository(at: indexPath.row) {
            cell.textLabel?.text = cellViewModel.title
            cell.detailTextLabel?.text = cellViewModel.description
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.useRepository(at: indexPath.row)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }

        viewModel.search(text: searchText) { [unowned self] result in
            switch result {
            case .success: self.tableView.reloadData()
            case .failure(let message): print(message)
            }
        }
    }
}
