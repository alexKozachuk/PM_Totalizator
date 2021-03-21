//
//  BetModalViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 19.03.2021.
//

import UIKit

class BetModalViewController: UIViewController {

    @IBOutlet weak var headerContainer: UIView?

    var isKeyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        headerContainer?.addBorder(side: .bottom)

        setupKeyboardNotifications()
    }

    var bottomSafeArea: CGFloat {
        return view.safeAreaInsets.bottom
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func placeBet() {
        print("Bet was placed")

        dismiss(animated: true, completion: nil)
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