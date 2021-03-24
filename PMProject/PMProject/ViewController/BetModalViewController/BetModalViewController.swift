//
//  BetModalViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit
import TotalizatorNetworkLayer

protocol BetModalDelegate {
    func placeBetDidTapped(amount: Double, possibleResult: PossibleResult)
}

class BetModalViewController: UIViewController {

    @IBOutlet weak var headerContainer: UIView?
    @IBOutlet weak var submitButton: UIButton?
    @IBOutlet weak var eventNameLabel: UILabel?
    @IBOutlet weak var betTextField: UITextField?
    @IBOutlet weak var possibleGainLabel: UILabel?
    
    var delegate: BetModalDelegate?
    var possibleResult: PossibleResult?
    var coordinator: MainCoordinator?

    private var event: Event?
    
    var isKeyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        headerContainer?.addBorder(side: .bottom)
        submitButton?.pmStyle()

        setupKeyboardNotifications()
        guard let event = event else { return }
        guard let possibleResult = possibleResult else { return }
        switch  possibleResult{
        case .w1:
            eventNameLabel?.text = "Bet on \(event.firstTeam.name)"
        case .w2:
            eventNameLabel?.text = "Bet on \(event.secondTeam.name)"
        case .x:
            eventNameLabel?.text = "Bet on draw"
        }
        
    }

    var bottomSafeArea: CGFloat {
        return view.safeAreaInsets.bottom
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func placeBet() {
        guard let amountText = betTextField?.text,
              let amount = Double(amountText),
              let possibleResult = possibleResult,
              amount > 0 else {
            return
        }

        if let coordinator = coordinator, !coordinator.authManager.isLoggedIn() {
            coordinator.presentProfileOrAuthorizationPage()
        }

        delegate?.placeBetDidTapped(amount: amount, possibleResult: possibleResult)
        dismiss(animated: true, completion: nil)
    }
}

extension BetModalViewController {
    
    func setup(event: Event, delegate: BetModalDelegate, coordinator: MainCoordinator, typeBet: PossibleResult) {
        self.event = event
        self.delegate = delegate
        self.coordinator = coordinator
        self.possibleResult = typeBet
    }
    
}

extension BetModalViewController: UITextFieldDelegate {

    @IBAction func textChanged(_ sender: UITextField) {
        if let text = sender.text, text.count > 0 {
            submitButton?.isEnabled = true
            submitButton?.isUserInteractionEnabled = true
            submitButton?.backgroundColor = .pmYellow
            if let bet = Double(text),
               let event = event,
               let possibleResult = possibleResult{
                let possibleGain = event.potentialGain(result: possibleResult, bet: bet)
                submitButton?
                    .setTitle("Зробити Ставку \(bet.rounded(places: 2)) UAH", for: .normal)
                possibleGainLabel?
                    .text = "Можлива Виплата \(possibleGain.rounded(places: 2)) UAH"
            }
        } else {
            submitButton?.isEnabled = false
            submitButton?.isUserInteractionEnabled = false
            submitButton?.backgroundColor = .gray
            submitButton?.setTitle("Зробити Ставку", for: .normal)
            possibleGainLabel?
                .text = "Можлива Виплата 0.00 UAH"
        }
    }

}

// MARK: - Keyboard hiding/showing handlers
private extension BetModalViewController {

    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardAppeared),
            name:  UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDissappeared),
            name:  UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func keyboardAppeared(notification: NSNotification) {
        if !isKeyboardShowing {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardSize.height - bottomSafeArea
            }

            isKeyboardShowing = true
        }

    }

    @objc func keyboardDissappeared(notification: NSNotification) {
        if isKeyboardShowing {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height - bottomSafeArea
            }

            isKeyboardShowing = false
        }
    }
}
