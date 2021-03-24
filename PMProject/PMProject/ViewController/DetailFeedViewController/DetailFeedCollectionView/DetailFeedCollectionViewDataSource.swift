//
//  DetailFeedCollectionViewDataSource.swift
//  PMProject
//
//  Created by Sasha on 19/03/2021.
//

import UIKit
import TotalizatorNetworkLayer

class DetailFeedCollectionViewDataSource: NSObject {

    weak var collectionView: UICollectionView?
    weak var coordinator: MainCoordinator?
    
    var event: Event?
    private var networkManager = NetworkManager()
    private var timer: DispatchSourceTimer?
    private let updateTime = 10
    
    var detailHeight: CGFloat {
        guard let event = event else { return 0 }
        
        if event.isLive {
            return 320
        } else {
            return 540
        }
        
    }
    
    var items: [CharacteristicsPair] {
        guard let event = event else { return [] }
        var values: [CharacteristicsPair] = []
        let first = event.firstTeam.characteristics
        let second = event.secondTeam.characteristics
        
        first.forEach { key, value in
            values.append(CharacteristicsPair(name: key,
                                              firstValue: value,
                                              secondValue: second[key] ?? ""))
        }
        return values
    }

}

extension DetailFeedCollectionViewDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailInfoCollectionViewCell else { return }
        let item = items[indexPath.row]
        cell.setup(with: item)
    }
    
}

extension DetailFeedCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: DetailInfoCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: DetailFeedCollectionReusableView.self, for: indexPath)
            
            if let event = event {
                reusableView.setup(with: event)
                reusableView.delegate = self
            }
            
            return reusableView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
}

extension DetailFeedCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: detailHeight)
    }
}

extension DetailFeedCollectionViewDataSource: DetailFeedCollectionReusableViewDelegate {

    func leftBetButtonDidTapped() {
        let eventName = "Bet on \(event?.firstTeam.name ?? "")"
        coordinator?.presentBetModal(eventName: eventName, delegate: self, typeBet: .w1)
    }

    func rightBetButtonDidTapped() {
        let eventName = "Bet on \(event?.secondTeam.name ?? "")"
        coordinator?.presentBetModal(eventName: eventName, delegate: self, typeBet: .w2)
    }

    func drawBetButtonDidTapped() {
        let eventName = "Bet on draw"
        coordinator?.presentBetModal(eventName: eventName, delegate: self, typeBet: .x)
    }
    
}

extension DetailFeedCollectionViewDataSource: BetModalDelegate {
    
    func placeBetDidTapped(amount: Double, possibleResult: PossibleResult) {
        guard let event = event else { return }
        networkManager.makeBet(amount: amount,
                               choice: possibleResult,
                               eventID: event.id) { [weak self] result in
            
            switch result {
            case .failure(let error):
                let ac = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                
                self?.coordinator?.navigationController.present(ac, animated: true)
            default:
                self?.updateEvent()
            }
            
          
        }
    }
    
}

private extension DetailFeedCollectionViewDataSource {
    
    func updateEvent() {
        
        guard let event = self.event else { return }
        
        networkManager.getEvent(by: event.id) { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error.rawValue)
            case .success(let eventResponse):
                self?.event = Event(event: eventResponse)
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        
        }
        
    }
    
}

// MARK: Timer

extension DetailFeedCollectionViewDataSource {
    
    func startTimer() {
        guard timer == nil else {
            return
        }

        let queue = DispatchQueue(label: "com.pmtech.totalizator.timer.DetailFeed", attributes: .concurrent)

        timer = DispatchSource.makeTimerSource(queue: queue)

        timer?.setEventHandler { [weak self] in
            guard let event = self?.event else { return }
            self?.networkManager.getEvent(by: event.id) { [weak self] result in
                
                switch result {
                case .failure(let error):
                    print(error.rawValue)
                case .success(let eventResponse):
                    self?.event = Event(event: eventResponse)
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
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
