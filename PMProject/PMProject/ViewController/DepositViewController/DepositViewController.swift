//
//  DepositViewController.swift
//  PMProject
//
//  Created by Sasha on 26/03/2021.
//

import UIKit
import TotalizatorNetworkLayer

class DepositViewController: BalanceProvidingViewController {
    
    @IBOutlet weak var submitButton: LoadingButton?
    @IBOutlet weak var moneyTextField: UITextField?
    
    var networkManager: NetworkManager?
    private var currentType: TransactionType = .deposit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }
    
    @IBAction func moneyButtonDidTapped() {
        guard let text = moneyTextField?.text,
              text != "",
              let amount = Double(text) else { return }
        
        submitButton?.showLoading()
        
        networkManager?.makeTransaction(amount: amount, type: currentType) { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let wallet):
                print(wallet)
            }
            
            DispatchQueue.main.async {
                self?.submitButton?.hideLoading()
                self?.moneyTextField?.text = nil
            }
            
        }
        
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl?) {
        guard let sender = sender else { return }
        switch sender.selectedSegmentIndex {
        case 0: 
            currentType = .deposit
            submitButton?.setTitle("Покласти", for: .normal)
        default:
            currentType = .withdraw
            submitButton?.setTitle("Зняти", for: .normal)
        }
        
    }
    
    override func update(balance: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let navigationItem = self?.navigationItem else {
                return
            }
            self?.coordinator?.displayWallet(navigationItem: navigationItem)
        }
    }
    
}

private extension DepositViewController {
    
    func setupNavbar() {
        
        coordinator?.balanceProviderDelegate = self
        coordinator?.displayWallet(navigationItem: navigationItem)
    }
    
}

