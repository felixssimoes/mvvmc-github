//
//  RepositoryDetailViewController.swift
//  mvvcc-demo
//
//  Created by Félix Simões on 19/06/16.
//  Copyright © 2016 Felix Simoes. All rights reserved.
//

import Foundation
import UIKit

private enum RepositoryDetailSection: Int {
    case header
    case body
}

private struct RepositoryDetailBodyData {
    let title: String
    let detail: String
    let callback: ((Void) -> Void)?
}

class RepositoryDetailViewController: UITableViewController {
    var viewModel: RepositoryDetailViewModel!
    fileprivate var bodyFields = [RepositoryDetailBodyData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        title = viewModel.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    fileprivate func updateUI() {
        bodyFields = [RepositoryDetailBodyData]()
        if viewModel.shouldShowOwner {
            bodyFields.append(RepositoryDetailBodyData(title: "User", detail: viewModel.userName, callback: { [unowned self] in
                self.viewModel.selectUser()
            }))
        }
        if let language = viewModel.language {
            bodyFields.append(RepositoryDetailBodyData(title: "Language", detail: language, callback: nil))
        }
        if let createdDate = viewModel.createdDate {
            bodyFields.append(RepositoryDetailBodyData(title: "Created", detail: createdDate, callback: nil))
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = RepositoryDetailSection(rawValue: section) else { fatalError() }
        switch section {
        case .header: return 1
        case .body: return bodyFields.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = RepositoryDetailSection(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! RepositoryDetailHeaderCell
            cell.titleLabel.text = viewModel.name
            cell.descriptionLabel.text = viewModel.description
            return cell
            
        case .body:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath)
            let data = bodyFields[indexPath.row]
            cell.textLabel?.text = data.title
            cell.detailTextLabel?.text = data.detail
            cell.selectionStyle = (data.callback == nil) ? .none : .default
            cell.accessoryType = (data.callback == nil) ? .none : .disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = RepositoryDetailSection(rawValue: indexPath.section) else { return }
        
        if section == .body {
            let data = bodyFields[indexPath.row]
            data.callback?()
        }
    }
}
