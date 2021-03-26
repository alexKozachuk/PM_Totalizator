//
//  AuthorizationManager.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import Foundation
import KeychainAccess
import TotalizatorNetworkLayer

class AuthorizationManager {
    
    private var networkManager: NetworkManager
    
    enum Key: String {
        case token
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    private let authKeychain = Keychain(service: "com.pm-tech.totalizator.auth")
    
    func isLoggedIn() -> Bool {
        return authKeychain.get(.token) != nil
    }
    
    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        
        networkManager.login(login: email, password: password) { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error.rawValue)
                completion("Неправильний пароль або логін")
            case .success(let token):
                do {
                    try self?.authKeychain.set(token.jwtString, key: .token)
                    NetworkManager.APIKey = token.jwtString
                    
                    print("User has successfully registered")
                    completion(nil)
                } catch {
                    completion(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    func register(email: String, password: String, dateOfBirth: Date, completion: @escaping (String?) -> Void) {
        
        networkManager.registration(login: email,
                                    password: password,
                                    dateOfBirth: dateOfBirth) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.rawValue)
            case .success(let token):
                do {
                    try self?.authKeychain.set(token.jwtString, key: .token)
                    NetworkManager.APIKey = token.jwtString
                    print("User has successfully registered")
                    
                    completion(nil)
                } catch {
                    completion(error.localizedDescription)
                }
            }
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
    
    func getToken() -> String? {
        return authKeychain.get(.token)
    }
}


