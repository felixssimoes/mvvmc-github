//
//  UserDetailHeaderCell.swift
//  mvvmc-github
//
//  Created by Felix Simoes on 16/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import UIKit

class UserDetailHeaderCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: UserDetailViewModel! {
        didSet {
            nameLabel.text = viewModel.name
        }
    }
}
