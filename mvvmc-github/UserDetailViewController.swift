//
//  UserDetailViewController.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 16/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import UIKit

extension UserDetailViewModelError: CustomStringConvertible {
    var description: String {
        switch self {
        case .failedLoadingRepositories: return "Error loading user's repositories"
        case .failedLoadingUser: return "Error loading user data"
        }
    }
}

class UserDetailViewController: UITableViewController {
    
    fileprivate enum Sections: Int {
        case header = 0
        case repositories = 1
        
        var cellIdentifier: String {
            switch self {
            case .header: return "HeaderCell"
            case .repositories: return "RepositoryCell"
            }
        }
    }
    
    var viewModel: UserDetailViewModel!
    
    // MARK:
    // MARK: View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        updateUI()

        if viewModel.isProfile {
            let logountButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.didSelectLogountButton))
            navigationItem.rightBarButtonItem = logountButton
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData { [weak self] result in
            switch result {
            case .success: self?.updateUI()
            case .failure(let error): print(error)
            }
            
        }
    }
    
    fileprivate func updateUI() {
        title = viewModel.isProfile ? "Profile" : viewModel.username
        tableView.reloadData()
    }

    // MARK:

    @IBAction func didSelectLogountButton() {
        viewModel.logout()
        tableView.reloadData()
    }

    // MARK:
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection indexPathSection: Int) -> Int {
        guard let section = Sections(rawValue: indexPathSection) else { fatalError() }
        
        switch section {
        case .header: return 1
        case .repositories: return viewModel.numberOfRepositories
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { fatalError() }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as! UserDetailHeaderCell
            cell.viewModel = viewModel
            return cell
        
        case .repositories:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
            if let repository = viewModel.repository(at: indexPath.row) {
                cell.textLabel?.text = repository.title
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.useRepository(at: indexPath.row)
    }
}
