//
//  LoginViewController.swift
//  mvvmc-github
//
//  Created by Félix Simões on 26/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import UIKit

extension AuthenticationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidUsername: return "Invalid user name"
        case .invalidPassword: return "Invalid password"
        case .invalidCredentials: return "User name or password are not correct"
        }
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    var viewModel: LoginViewModel!

    @IBAction func didSelectLogin() {
        viewModel.username = usernameField.text
        viewModel.password = passwordField.text

        viewModel.login { [weak self] result in
            if case .failure(let e) = result {
                self?.showErrorMessage(e.description)
            }
        }
    }

    @IBAction func didSelectCancel() {
        viewModel.cancel()
    }

    fileprivate func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Login", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
