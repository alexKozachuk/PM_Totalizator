//
//  ProfileViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let authManager = AuthorizationManager()

    @IBAction func logout() {
        authManager.logout() { [weak self] error in
            guard error == nil else {
                print(error!)
                return
            }

            self?.coordinator?.popBack()
        }
    }
}
