//
//  RegisterViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var authManager: AuthorizationManager?
    private let validator = LoginValidator()
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var submitButton: LoadingButton?
    @IBOutlet weak var errorLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton?.pmStyle()
    }
    
    @IBAction func register() {
        
        guard let email = emailField?.text, let password = passwordField?.text, let date = datePicker?.date else {
            return
        }
        
        switch validator.validate(email: email, password: password, dateOfBirth: date) {
        case .emptyPassword:
            setError("The password field is empty")
            return
        case .invalidPassword:
            setError("Password is too short")
        case .emptyEmail:
            setError("The Email field is empty")
            return
        case .invalidEmail:
            setError("Invalid Email")
            return
        case .invalidAge:
            setError("You are not 18 years old")
            return
        case .success:
            break
        }
        
        submitButton?.showLoading()
        authManager?.register(email: email, password: password, dateOfBirth: date) { [weak self] error in
            
            DispatchQueue.main.async {
                self?.submitButton?.hideLoading()
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.setError(error)
                }
                return
            }
            DispatchQueue.main.async {
                self?.coordinator?.popToRoot()
            }
        }
        
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
