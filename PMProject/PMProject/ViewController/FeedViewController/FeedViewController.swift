//
//  FeedViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

class FeedViewController: BalanceProvidingViewController {
    
    @IBOutlet weak var chatViewConstraint: NSLayoutConstraint!
    private let authManager = AuthorizationManager()
    private let networkManager = NetworkManager()
    private let updateTime = 10
    
    private var timer: DispatchSourceTimer?
    private var eventsDataSource: EventsCollectionViewDataSource?
    private var chatDataSource: ChatCollectionViewDataSource?
    private var collectionViewLayout: UICollectionViewFlowLayout?
    
    @IBOutlet weak var eventsCollectionView: UICollectionView?
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var eventsLoaderIndicator: UIActivityIndicatorView?
    @IBOutlet weak var messageTextView: UITextView?
    
    override func viewWillLayoutSubviews() {
        chatViewConstraint.constant = view.frame.height
        setupTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupCollectionView()
        setupData()
        setupChatMock()
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
        
        chatDataSource = ChatCollectionViewDataSource()
        chatCollectionView?.dataSource = chatDataSource
        chatCollectionView?.delegate = chatDataSource
        
        chatCollectionView?.register(type: OwnMessageCollectionViewCell.self)
        chatCollectionView?.register(type: MessageCollectionViewCell.self)
        chatCollectionView?.contentInsetAdjustmentBehavior = .always
        
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        if let collectionViewLayout = collectionViewLayout {
            chatCollectionView?.collectionViewLayout = collectionViewLayout
        }
        
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
    
    func setupChatMock() {
        let array = [
            Message(userId: "qwerty", text: "Гайз порекомендуйте на кого ставити? А то я зі своїм везінням всі гроші програю", name: "Ви"),
            Message(userId: "1234", text: "Я б ставив би все на NAVI", name: "Алекс"),
            Message(userId: "qwerty", text: "А норм будуть пропозиції?", name: "Ви"),
            Message(userId: "123", text: "ХЗ, я вже почку на них поставив", name: "Бот"),
            Message(userId: "432", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. deserunt mollit anim id est laborum.", name: "Діма"),
            Message(userId: "6432", text: "Кікніть Діму за спам.", name: "Олег"),
            Message(userId: "qwerty", text: "ОК, зрозумів розходимся", name: "Ви")
        ]
        
        chatDataSource?.items = array
        chatCollectionView.reloadData()
    }
    
    func setupTextView() {
        messageTextView?.centerVertically()
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
