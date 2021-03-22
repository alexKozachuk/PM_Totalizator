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

    @IBOutlet weak var eventsCollectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        setupCollectionView()
        setupMockData()
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
        eventsDataSource?.coordinator = coordinator

        eventsCollectionView?.dataSource = eventsDataSource
        eventsCollectionView?.delegate = eventsDataSource

        eventsCollectionView?.register(type: EventCollectionViewCell.self)
    }
    
    func setupMockData() {
        
        let team1 = Team(id: 1,
                         name: "Dong Hyun Kim",
                         imageUrl: "mock url",
                         characteristics: ["Weight (kg)": "65",
                                           "Height (cm)": "154",
                                           "Age": "31"])
        let team2 = Team(id: 2,
                         name: "Colby Covington",
                         imageUrl: "mock url",
                         characteristics: ["Weight (kg)": "68",
                                           "Height (cm)": "170",
                                           "Age": "28"])
        let team3 = Team(id: 3,
                         name: "Jon Jones",
                         imageUrl: "mock url",
                         characteristics: ["Weight (kg)": "69",
                                           "Height (cm)": "164",
                                           "Age": "33"])
        let team4 = Team(id: 4,
                         name: "Khabilov Rustam",
                         imageUrl: "mock url",
                         characteristics: ["Weight (kg)": "68",
                                           "Height (cm)": "168",
                                           "Age": "27"])
        
        eventsDataSource?.items = [
            Event(id: 1, firstTeam: team1, secondTeam: team2,
                  betSum: BetSum(firstBet: 17600, secondBet: 10500, drawBet: 1700),
                  startTime: Date(timeIntervalSince1970: 1617112869)),
            Event(id: 2, firstTeam: team3, secondTeam: team4,
                  betSum: BetSum(firstBet: 9600, secondBet: 13500, drawBet: 1100)),
            Event(id: 3, firstTeam: team3, secondTeam: team2,
                  betSum: BetSum(firstBet: 6500, secondBet: 8500, drawBet: 500),
                  startTime: Date(timeIntervalSince1970: 1617112869))
        
        ]
        
        eventsCollectionView?.reloadData()
        
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

