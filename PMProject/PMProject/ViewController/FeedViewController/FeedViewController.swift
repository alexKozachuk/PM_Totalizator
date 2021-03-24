//
//  FeedViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

class FeedViewController: BalanceProvidingViewController {

    private let authManager = AuthorizationManager()
    private let networkManager = NetworkManager()
    private let updateTime = 10
    
    private var timer: DispatchSourceTimer?
    private var eventsDataSource: EventsCollectionViewDataSource?

    @IBOutlet weak var eventsCollectionView: UICollectionView?
    @IBOutlet weak var eventsLoaderIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        setupCollectionView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.startTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    // MARK: - BalanceProviderDelegate
    override func update(balance: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let navigationItem = self?.navigationItem else {
                return
            }

            self?.coordinator?.displayWallet(navigationItem: navigationItem)
        }
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
    
    func setupData() {
        self.showLoaderEvent()
        networkManager.feed { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoaderEvent()
            }
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let feed):
                self?.eventsDataSource?.items = feed.events.map {Event(event: $0)}
                DispatchQueue.main.async {
                    self?.eventsCollectionView?.reloadData()
                }
            }
            
        }
    }
    
    func setupTimer() {
        
    }
}

// MARK: - Navigation bar setup
private extension FeedViewController {

    func setupNavbar() {
        setupLogo()
        coordinator?.displayWallet(navigationItem: navigationItem)
    }

    func setupLogo() {
        let logoImage = UIImageView(image: UIImage(named: "pm_logo"))
        let barButton = UIBarButtonItem(customView: logoImage)

        barButton.customView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

        navigationItem.setLeftBarButton(barButton, animated: true)
    }
    
}

// MARK: Events Loader Indicator Methods

private extension FeedViewController {
    
    func showLoaderEvent() {
        eventsLoaderIndicator?.isHidden = false
        eventsLoaderIndicator?.startAnimating()
    }
    
    func hideLoaderEvent() {
        eventsLoaderIndicator?.isHidden = true
        eventsLoaderIndicator?.stopAnimating()
    }
    
}

// MARK: Timer

private extension FeedViewController {
    
    func startTimer() {
        guard timer == nil else {
            return
        }

        let queue = DispatchQueue(label: "com.pmtech.totalizator.timer.Feed", attributes: .concurrent)

        timer = DispatchSource.makeTimerSource(queue: queue)

        timer?.setEventHandler { [weak self] in
            self?.networkManager.feed { result in
                
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let feed):
                    self?.eventsDataSource?.items = feed.events.map {Event(event: $0)}
                    DispatchQueue.main.async {
                        self?.eventsCollectionView?.reloadData()
                    }
                }
                
            }

        }

        timer?.schedule(deadline: .now(), repeating: .seconds(updateTime))

        timer?.resume()
        print("started")
    }

    func stopTimer() {
        timer = nil
        print("stopped")
    }
    
    
}
