//
//  OnboardingViewController.swift
//  PMProject
//
//  Created by Dmytro Yurchennko on 28.03.2021.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingProgress: UIProgressView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    
    var onboardingScreen = OnboardingScreens.players
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPlayersOnboarding()
    }
    
    @IBAction func back(_ sender: UIButton) {
        changeOnboarding(with: .back)
    }
    
    @IBAction func next(_ sender: UIButton) {
        changeOnboarding(with: .next)
    }
    
    enum OnboardingScreens {
        case players
        case chat
        case commisions
    }
    
    enum Action {
        case back
        case next
    }
    
    func displayPlayersOnboarding() {
        mainImage.image = #imageLiteral(resourceName: "Group")
        imageCaption.text = "Bet on winner - grab losers money. The more you bet, the more prize share you get. When event started - bets stopped, video stream begins."
        onboardingProgress.progress = 0.33
    }
    
    func displayChatOnboarding() {
        mainImage.image = #imageLiteral(resourceName: "Group-1")
        imageCaption.text = "1% comission from bet sum Bookmaker doesn’t play, bookmaker guarantees"
        onboardingProgress.progress = 0.66
    }
    
    func displayCommisionsOnboarding() {
        mainImage.image = #imageLiteral(resourceName: "Group-2")
        imageCaption.text = "Application chat brings fun to the game."
        onboardingProgress.progress = 1
    }
    
    func changeOnboarding(with action: Action) {
        
        if action == .next {
            switch onboardingScreen {
                case .players:
                    displayChatOnboarding()
                    
                    onboardingScreen = .chat
                    
                case .chat:
                    displayCommisionsOnboarding()
                    
                    onboardingScreen = .commisions
                    
                case .commisions:
                    dismiss(animated: true, completion: nil)
                    Core.shared.setAlreadyOpened()
                    return
            }
            
        } else {
            switch onboardingScreen {
                case .players:
                    return
                    
                case .chat:
                    displayPlayersOnboarding()
                    
                    onboardingScreen = .players
                    
                case .commisions:
                    displayChatOnboarding()
                    
                    onboardingScreen = .chat
            }
        }
        
    }
}


