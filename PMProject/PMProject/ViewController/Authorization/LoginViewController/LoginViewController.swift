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
    private let validator = LoginValidator()

    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var submitButton: UIButton?
    @IBOutlet weak var errorLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton?.pmStyle()
        
        setupNavbar()
    }

    @IBAction func login() {
        guard let email = emailField?.text,
              let password = passwordField?.text else {
            return
        }
        
        switch validator.validate(email: email, password: password) {
        case .emptyPassword:
            setError("Поле пароль пусте")
            return
        case .emptyEmail:
            setError("Поле Email пусте")
            return
        case .invalidEmail:
            setError("Невалідний Email")
            return
        case .success:
            break
        }

        authManager.login(email: email, password: password) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.setError("Невірно вказаний логін або пароль")
                }
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
    
    func setError(_ text: String) {
        setErrorTextFied(self.emailField)
        setErrorTextFied(self.passwordField)
        errorLabel?.text = text
        errorLabel?.isHidden = false
    }
    
    func setErrorTextFied(_ textField: UITextField?) {
        textField?.layer.borderWidth = 1
        textField?.layer.cornerRadius = 5
        textField?.layer.borderColor = UIColor.red.cgColor
        textField?.textColor = .red
    }
    
    func setNormalTextFied(_ textField: UITextField?) {
        textField?.layer.borderWidth = 0
        textField?.layer.cornerRadius = 0
        textField?.layer.borderColor = UIColor.clear.cgColor
        textField?.textColor = .label
    }
    
    @IBAction func textFiedlEditingChanged() {
        setNormalTextFied(passwordField)
        setNormalTextFied(emailField)
        errorLabel?.isHidden = true
    }
    
}

private extension LoginViewController {

    func setupNavbar() {
        title = "Ввійти"

        let registerNavBarButton = UIBarButtonItem(title: "Реєстрація", style: .plain, target: self, action: #selector(goToRegisterPage))

        navigationItem.setRightBarButton(registerNavBarButton, animated: true)
    }
}
