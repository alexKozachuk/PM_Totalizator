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
    
    var delegate: BetModalDelegate?
    var possibleResult: PossibleResult?
    private var eventName: String?
    
    var isKeyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        headerContainer?.addBorder(side: .bottom)
        submitButton?.pmStyle()

        setupKeyboardNotifications()
        eventNameLabel?.text = eventName
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
        delegate?.placeBetDidTapped(amount: amount, possibleResult: possibleResult)
        dismiss(animated: true, completion: nil)
    }
}

extension BetModalViewController {
    
    func setup(eventName: String, delegate: BetModalDelegate, typeBet: PossibleResult) {
        self.eventName = eventName
        self.delegate = delegate
        self.possibleResult = typeBet
    }
    
}

extension BetModalViewController: UITextFieldDelegate {

    @IBAction func textChanged(_ sender: UITextField) {
        if let text = sender.text, text.count > 0 {
            submitButton?.isEnabled = true
            submitButton?.backgroundColor = .pmYellow
        } else {
            submitButton?.isEnabled = false
            submitButton?.backgroundColor = .gray
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
