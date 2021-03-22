//
//  BalanceProvidingViewController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 22.03.2021.
//

import UIKit

class BalanceProvidingViewController: UIViewController, Coordinated {

    weak var coordinator: MainCoordinator?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        coordinator?.balanceProviderDelegate = self
        coordinator?.balanceNeeded()
        coordinator?.update()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        guard let navigationController = navigationController else {
            return
        }

        coordinator?.balanceProviderDelegate = nil

        if isMovingFromParent {
            let count = navigationController.viewControllers.count

            let index = count - 1

            if navigationController.viewControllers[index] is BalanceProvidingViewController {
                return
            } else {
                coordinator?.discardBalanceFetching()
            }
        } else {
            if navigationController.viewControllers.last is BalanceProvidingViewController {
                return
            } else {
                coordinator?.discardBalanceFetching()
            }
        }
    }
}

extension BalanceProvidingViewController: BalanceProviderDelegate {

    @objc func update(balance: Double) {

    }
}
