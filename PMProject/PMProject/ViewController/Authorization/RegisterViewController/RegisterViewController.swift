//
//  RegisterViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

class RegisterViewController: UIViewController {

    private let authManager = AuthorizationManager()

    weak var coordinator: MainCoordinator?

    @IBOutlet weak var nameField: UITextField?
    @IBOutlet weak var loginField: UITextField?
    @IBOutlet weak var passwordField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func register() {
        guard let name = nameField?.text, let login = loginField?.text, let password = passwordField?.text else {
            return
        }
        authManager.register(name: name, login: login, password: password) { [weak self] error in
            guard error == nil else {
                print(error!)
                return
            }

            self?.coordinator?.popToRoot()
        }
    }
}
