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
    
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var submitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton?.pmStyle()
    }
    
    @IBAction func register() {
        
        guard let email = emailField?.text, let password = passwordField?.text, let date = datePicker?.date else {
            return
        }
        
        authManager.register(email: email, password: password, dateOfBirth: date) { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self?.coordinator?.popToRoot()
            }
        }
        
    }
}
