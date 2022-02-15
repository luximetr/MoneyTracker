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
        
    init(account: Account, localizer: ScreenLocalizer) {
        self.account = account
        self.localizer = localizer
        super.init()
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerAction))
        panGestureRecognizerDelegate.accountCollectionViewCellController = self
        panGestureRecognizer.delegate = panGestureRecognizerDelegate
    }
    
    // MARK Collection View Cell
    
    var accountCollectionViewCell: AccountsScreenView.AccountCollectionViewCell? {
        return collectionViewCell as? AccountsScreenView.AccountCollectionViewCell
    }
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let panGestureRecognizerDelegate = UIGestureRecognizerDelegateProxy()
    
    override func setupCollectionViewCell() {
        super.setupCollectionViewCell()
        accountCollectionViewCell?.deleteButton.addTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
        accountCollectionViewCell?.accountView.addGestureRecognizer(panGestureRecognizer)
        setContent()
    }
    
    override func unsetupCollectionViewCell() {
        accountCollectionViewCell?.deleteButton.removeTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
        accountCollectionViewCell?.accountView.removeGestureRecognizer(panGestureRecognizer)
        super.unsetupCollectionViewCell()
    }
    
    // MARK: Localizer
    
    private let localizer: ScreenLocalizer
    
    // MARK: Conten
    
    private func setContent() {
        accountCollectionViewCell?.nameLabel.text = account.name
        accountCollectionViewCell?.balanceLabel.text = "\(account.balance.amount.description) \(account.balance.currency.rawValue)"
        accountCollectionViewCell?.accountView.backgroundColor = account.backgroundColor
        accountCollectionViewCell?.deleteButton.setTitle(localizer.localizeText("deleteAccount"), for: .normal)
    }
    
    // MARK: Events
    
    var didDeleteClosure: (() -> Void)?
    @objc private func deleteButtonTouchUpInsideEventAction() {
        didDeleteClosure?()
    }
    
    private var previousPanGestureRecognizerTranslation: CGPoint?
    @objc private func panGestureRecognizerAction() {
        guard let accountCollectionViewCell = accountCollectionViewCell else { return }
        let state = panGestureRecognizer.state
        switch state {
        case .began:
            previousPanGestureRecognizerTranslation = panGestureRecognizer.translation(in: collectionViewCell)
        case .possible:
            break
        case .changed:
            if let previousPanGestureRecognizerTranslation = previousPanGestureRecognizerTranslation {
                let translation = panGestureRecognizer.translation(in: collectionViewCell)
                let j = translation.x - previousPanGestureRecognizerTranslation.x
                accountCollectionViewCell.moveAccountViewIfPossible(j)
                self.previousPanGestureRecognizerTranslation = translation
            }
        case .ended:
            accountCollectionViewCell.finishMove()
        case .cancelled:
            accountCollectionViewCell.finishMove()
        case .failed:
            accountCollectionViewCell.finishMove()
        @unknown default:
            accountCollectionViewCell.finishMove()
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    fileprivate func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panGestureRecognizer == gestureRecognizer, let accountView = accountCollectionViewCell?.accountView {
            let velocity = panGestureRecognizer.velocity(in: accountView)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }

}

private class UIGestureRecognizerDelegateProxy: NSObject, UIGestureRecognizerDelegate {
    
    weak var accountCollectionViewCellController: AccountCollectionViewCellController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return accountCollectionViewCellController?.gestureRecognizerShouldBegin(gestureRecognizer) ?? false
    }
    
}
}
