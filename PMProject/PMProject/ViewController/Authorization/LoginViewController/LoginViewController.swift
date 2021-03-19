//
//  LoginViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

class LoginViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let authManager = AuthorizationManager()

    @IBOutlet weak var loginField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var submitButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
    }

    @IBAction func login() {
        guard let loginField = loginField, let passwordField = passwordField else {
            return
        }

        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""

        authManager.login(login: login, password: password) { [weak self] error in
            guard error == nil else {
                print(error!)
                return
            }

            self?.coordinator?.popBack()
        }
    }

    @objc func goToRegisterPage() {
        let registerVC = RegisterViewController()
        registerVC.coordinator = coordinator

        coordinator?.navigationController.pushViewController(registerVC, animated: true)
    }
}

private extension LoginViewController {

    func setupNavbar() {
        title = "Ввійти"

        let registerNavBarButton = UIBarButtonItem(title: "Реєстрація", style: .plain, target: self, action: #selector(goToRegisterPage))

        navigationItem.setRightBarButton(registerNavBarButton, animated: true)
    }
}