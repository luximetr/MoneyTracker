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
        
    private(set) var account: Account
    private(set) var appearance: Appearance
    
    // MARK: Initializer
        
    init(account: Account, localizer: ScreenLocalizer, appearance: Appearance) {
        self.account = account
        self.localizer = localizer
        self.appearance = appearance
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
    
    var accountCollectionViewCell: AccountCollectionViewCell? {
        return collectionViewCell as? AccountCollectionViewCell
    }
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let panGestureRecognizerDelegate = UIGestureRecognizerDelegateProxy()
    
    override func setupCollectionViewCell() {
        super.setupCollectionViewCell()
        accountCollectionViewCell?.deleteButton.addTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
        accountCollectionViewCell?.accountView.addGestureRecognizer(panGestureRecognizer)
        setContent()
        setAppearance(appearance)
    }
    
    override func unsetupCollectionViewCell() {
        accountCollectionViewCell?.deleteButton.removeTarget(self, action: #selector(deleteButtonTouchUpInsideEventAction), for: .touchUpInside)
        accountCollectionViewCell?.accountView.removeGestureRecognizer(panGestureRecognizer)
        super.unsetupCollectionViewCell()
    }
    
    // MARK: Localizer
    
    private let localizer: ScreenLocalizer
    
    // MARK: Content
    
    private func setContent() {
        accountCollectionViewCell?.nameLabel.text = account.name
        accountCollectionViewCell?.balanceLabel.text = "\(account.amount.description) \(account.currency.rawValue)"
        accountCollectionViewCell?.deleteButton.setTitle(localizer.localizeText("deleteAccount"), for: .normal)
        accountCollectionViewCell?.accountView.setNeedsLayout()
        accountCollectionViewCell?.accountView.layoutIfNeeded()
    }
    
    // MARK: - Appearance
    
    private let uiColorProvider = AccountColorUIColorProvider()
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        let accountUIColor = uiColorProvider.getUIColor(accountColor: account.color, appearance: appearance)
        accountCollectionViewCell?.accountView.backgroundColor = accountUIColor
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
    
    func editAccount(_ editedAccount: Account) {
        account = editedAccount
        setContent()
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

fileprivate class UIGestureRecognizerDelegateProxy: NSObject, UIGestureRecognizerDelegate {
    
    weak var accountCollectionViewCellController: AccountCollectionViewCellController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return accountCollectionViewCellController?.gestureRecognizerShouldBegin(gestureRecognizer) ?? false
    }
    
}
}
