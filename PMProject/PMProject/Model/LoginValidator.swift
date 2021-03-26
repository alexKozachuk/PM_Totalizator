//
//  LoginValidator.swift
//  PMProject
//
//  Created by Sasha on 22/03/2021.
//

import Foundation

enum LoginValidatorError: Error {
    case emptyPassword
    case invalidPassword
    case emptyEmail
    case invalidEmail
    case invalidAge
    case success
}

class LoginValidator {
    
    func validate(email: String, password: String, dateOfBirth: Date? = nil) -> LoginValidatorError {
        
        if email == "" {
            return .emptyEmail
        }
        
        if password == "" {
            return .emptyPassword
        }

        if password.count < 6 {
            return .invalidPassword
        }
        
        guard isValidEmail(email) else {
            return .invalidEmail
        }

        if let dateOfBirth = dateOfBirth, Date().timeIntervalSinceNow - dateOfBirth.timeIntervalSinceNow < 568036800 {
            return .invalidAge
        }
        
        return .success
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
