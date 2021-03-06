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
    var authManager: AuthorizationManager?
    var networkManager: NetworkManager?
    var timeInterval: Int = 5
    
    var timer: DispatchSourceTimer?
    var timerLabel = "com.pmtech.totalizator.timer.Feed"
    private var eventsDataSource: EventsCollectionViewDataSource?
    private var chatDataSource: ChatCollectionViewDataSource?
    private var collectionViewLayout: UICollectionViewFlowLayout?
    
    @IBOutlet weak var eventsCollectionView: UICollectionView?
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var eventsLoaderIndicator: UIActivityIndicatorView?
    @IBOutlet weak var messageTextView: UITextView?
    
    override func viewWillLayoutSubviews() {
        chatViewConstraint.constant = view.frame.height
            - view.layoutMargins.top
            - view.layoutMargins.bottom
        setupMessageTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupCollectionView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.startUpdating()
        }
        setupMessageTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopUpdating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkChat()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.shared.openingAppFirstTime() {
            let onboarding = OnboardingViewController()
            onboarding.modalPresentationStyle = .fullScreen
            present(onboarding, animated: true)
        }
        
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
    
    @IBAction func sendButtonTapped() {
        guard let text = messageTextView?.text, text != "" else { return }
        networkManager?.sendMessage(text: text) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                DispatchQueue.main.async {
                    self?.setupChatData()
                    self?.messageTextView?.text = nil
                }
            }
        }
        
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
        networkManager?.feed { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoaderEvent()
            }
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let feed):
                let feed = feed.events.map {Event(event: $0)}
                if let hash = self?.eventsDataSource?.items.hashValue, hash == feed.hashValue {
                    return
                }
                self?.eventsDataSource?.items = feed
                DispatchQueue.main.async {
                    self?.eventsCollectionView?.reloadData()
                }
            }
            
        }
    }
    
    func setupChatData() {
        
        guard let userInfo = authManager?.userInfo else { return }
        chatDataSource?.currentId = userInfo.id
        
        networkManager?.getChat { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error.rawValue)
            case .success(let chat):
                let chat = chat.messages.map { Message(message: $0) }
                if let hash = self?.chatDataSource?.items.hashValue, hash == chat.hashValue {
                    return
                }
                self?.chatDataSource?.items = Array(chat)
                DispatchQueue.main.async {
                    self?.chatCollectionView.reloadData()
                }
            }
            
        }
        
    }
    
    func setupMessageTextView() {
        messageTextView?.centerVertically()
        messageTextView?.text = "Enter the text"
        messageTextView?.textColor = UIColor.lightGray
        messageTextView?.delegate = self
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

extension FeedViewController: EventUpdating {
    func eventHandler() {
        self.networkManager?.feed { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let feed):
                let feed = feed.events.map {Event(event: $0)}
                if let hash = self?.eventsDataSource?.items.hashValue, hash == feed.hashValue {
                    return
                }
                self?.eventsDataSource?.items = feed
                DispatchQueue.main.async {
                    self?.eventsCollectionView?.reloadData()
                }
            }
            
        }
        
        if self.authManager?.isLoggedIn() ?? false {
            self.setupChatData()
        }
    }
    
}

private extension FeedViewController {
    
    func checkChat() {
        if authManager?.isLoggedIn() ?? false {
            setupChatData()
        } else {
            chatDataSource?.items = []
            chatCollectionView.reloadData()
        }
    }
    
}

extension FeedViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the text"
            textView.textColor = UIColor.lightGray
            textView.centerVertically()
        }
    }
    
}
