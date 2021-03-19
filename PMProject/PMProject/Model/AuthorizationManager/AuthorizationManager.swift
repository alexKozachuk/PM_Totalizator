//
//  AuthorizationManager.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import Foundation
import KeychainAccess

class AuthorizationManager {

    enum Key: String {
        case token
    }

    private let authKeychain = Keychain(service: "com.pm-tech.totalizator.auth")

    func isLoggedIn() -> Bool {
        return authKeychain.get(.token) != nil
    }

    func login(login: String, password: String, completion: @escaping (Error?) -> Void) {
        do {
            try authKeychain.set("\(password)", key: .token)
            print("User has successfully signed in")

            completion(nil)
        } catch {
            completion(error)
        }
    }

    func register(name: String, login: String, password: String, completion: @escaping (Error?) -> Void) {
        do {
            try authKeychain.set("\(password)", key: .token)
            print("User has successfully registered")

            completion(nil)
        } catch {
            completion(error)
        }
    }

    func logout(completion: @escaping (Error?) -> Void) {
        do {
            try authKeychain.remove(.token)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
