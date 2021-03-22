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
        guard let login = loginField?.text,
              let password = passwordField?.text else {
            return
        }

        authManager.login(email: login, password: password) { [weak self] error in
            if let error = error {
                print(error)
                return
            }

            DispatchQueue.main.async {
                self?.coordinator?.popBack()
            }
            
        }
    }

    @objc func goToRegisterPage() {
        coordinator?.presentRegistrationPage()
    }
}

private extension LoginViewController {

    func setupNavbar() {
        title = "Ввійти"

        let registerNavBarButton = UIBarButtonItem(title: "Реєстрація", style: .plain, target: self, action: #selector(goToRegisterPage))

        navigationItem.setRightBarButton(registerNavBarButton, animated: true)
    }
}
