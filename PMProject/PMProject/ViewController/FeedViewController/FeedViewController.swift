//
//  FeedViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

class FeedViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
    }

}

private extension FeedViewController {

    @objc func profileButtonTapped() {
        coordinator?.presentProfileOrAuthorizationPage()
    }
}

// MARK: - Navigation bar setup
private extension FeedViewController {

    func setupNavbar() {
        navigationController?.navigationBar.barStyle = .black

        setupLogo()
        setupProfileButton()
    }

    func setupLogo() {
        let logoImage = UIImageView(image: UIImage(named: "pm_logo"))
        let barButton = UIBarButtonItem(customView: logoImage)

        barButton.customView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

        navigationItem.setLeftBarButton(barButton, animated: true)
    }

    func setupProfileButton() {
        let iconLength: CGFloat = 30

        let profilePicture = getProfilePicture()

        let profileButton = UIButton()

        profileButton.setImage(profilePicture, for: .normal)
        profileButton.backgroundColor = .white
        profileButton.layer.masksToBounds = true
        profileButton.tintColor = .black

        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        let profileBarButton = UIBarButtonItem(customView: profileButton)

        profileBarButton.customView?.widthAnchor.constraint(
            equalToConstant: iconLength
        ).isActive = true
        profileBarButton.customView?.heightAnchor.constraint(
            equalToConstant: iconLength
        ).isActive = true

        profileBarButton.customView?.layer.cornerRadius = iconLength / 2

        navigationItem.setRightBarButton(profileBarButton, animated: true)
    }

    func getProfilePicture() -> UIImage {
        let image = UIImage(systemName: "person.fill")!

        return image
    }
}

