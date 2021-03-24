//
//  PresentationController.swift
//  PMProject
//
//  Created by Ilya Senchukov on 21.03.2021.
//

import UIKit

class PresentationController: UIPresentationController {

    var bottomSafeArea: CGFloat {
        return containerView!.safeAreaInsets.bottom
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let height: CGFloat = 240 + bottomSafeArea


        return CGRect(x: 0,
                      y: bounds.height - height,
                      width: bounds.width,
                      height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
