//
//  AccountsScreenAccountCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 09.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenViewController {
final class AccountCollectionViewCellController: AUIClosuresCollectionViewCellController {
        
    // MARK: Data
        
    let account: Account
    
    // MARK: Initializer
        
    init(account: Account) {
        self.account = account
        super.init()
    }
    
    // MARK: Events
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = super.cellForItemAtIndexPath(indexPath) as! AccountsScreenView.AccountCollectionViewCell
        self.collectionViewCell = collectionViewCell
        collectionViewCell.nameLabel.text = account.name
        collectionViewCell.balanceLabel.text = account.balance.description
        collectionViewCell.accountView.backgroundColor = account.backgroundColor
        setupCollectionViewCell()
        return collectionViewCell
    }
    
    override func didEndDisplayingCell() {
        super.didEndDisplayingCell()
        unsetupCollectionViewCell()
        collectionViewCell = nil
    }
    
    // MARK Collection View Cell
    
    var accountCollectionViewCell: AccountsScreenView.AccountCollectionViewCell? {
        return collectionViewCell as? AccountsScreenView.AccountCollectionViewCell
    }
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let swipeGestureRecognizer = UISwipeGestureRecognizer()
    
    override func setupCollectionViewCell() {
        super.setupCollectionViewCell()
        accountCollectionViewCell?.deleteView.addTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
        //panGestureRecognizer.require(toFail: swipeGestureRecognizer)
        accountCollectionViewCell?.accountView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerAction))
        
        //collectionViewCell?.accountView.addGestureRecognizer(swipeGestureRecognizer)
        swipeGestureRecognizer.addTarget(self, action: #selector(swipeGestureRecognizerAction))
        
        accountCollectionViewCell?.deleteView.addTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
    }
    
    override func unsetupCollectionViewCell() {
        accountCollectionViewCell?.deleteView.removeTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
        accountCollectionViewCell?.accountView.removeGestureRecognizer(panGestureRecognizer)
        accountCollectionViewCell?.accountView.removeGestureRecognizer(swipeGestureRecognizer)
        super.unsetupCollectionViewCell()
    }
    
    var didDeleteClosure: (() -> Void)?
    @objc private func deleteButtonTouchUpInsideEventAction() {
        didDeleteClosure?()
    }
    
    private var panBeganPoint: CGPoint?
    @objc private func panGestureRecognizerAction() {
        guard let accountCollectionViewCell = accountCollectionViewCell else { return }
        let state = panGestureRecognizer.state
        switch state {
        case .began:
            panBeganPoint = panGestureRecognizer.view?.center
        case .possible:
            break
        case .changed:
            let translation = panGestureRecognizer.translation(in: collectionViewCell)
            accountCollectionViewCell.xOffset = translation.x
            print(translation)
        case .ended:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func swipeGestureRecognizerAction() {
        guard let accountCollectionViewCell = accountCollectionViewCell else { return }
        let direction = swipeGestureRecognizer.direction
        switch direction {
        case .left:
             print("left")
        case .right:
            print("right")
        case .down:
            break
        case .up:
            break
        default:
            break
        }
    }

}
}
