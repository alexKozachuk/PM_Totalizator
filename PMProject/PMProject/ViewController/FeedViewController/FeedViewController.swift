//
//  FeedViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit

class FeedViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let authManager = AuthorizationManager()

    private var eventsDataSource: EventsCollectionViewDataSource?
    private var eventsCollectionViewDelegate: EventsCollectionViewDelegate?

    @IBOutlet weak var eventsCollectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        setupCollectionView()
    }

}

private extension FeedViewController {

    @objc func profileButtonTapped() {
        coordinator?.presentProfileOrAuthorizationPage()
    }
}

private extension FeedViewController {

    func setupCollectionView() {
        eventsDataSource = EventsCollectionViewDataSource()
        eventsCollectionView?.dataSource = eventsDataSource

        eventsCollectionViewDelegate = EventsCollectionViewDelegate()
        eventsCollectionView?.delegate = eventsCollectionViewDelegate

        let reuseIdentifier = EventCollectionViewCell.reuseIdentifier

        eventsCollectionView?.register(
            UINib(nibName: reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier)

    }
}

// MARK: - Navigation bar setup
private extension FeedViewController {

    func setupNavbar() {
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

