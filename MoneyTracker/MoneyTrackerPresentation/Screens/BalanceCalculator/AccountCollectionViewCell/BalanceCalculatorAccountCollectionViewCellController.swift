//
//  AccountsScreenAccountCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit

extension BalanceCalculatorScreenViewController {
final class AccountCollectionViewCellController: AUIClosuresCollectionViewCellController {
        
    // MARK: Data
        
    private(set) var account: Account
    private(set) var appearance: Appearance
    
    // MARK: Initializer
        
    init(account: Account, appearance: Appearance) {
        self.account = account
        self.appearance = appearance
        super.init()
    }
    
    // MARK: Collection View Cell
    
    var accountCollectionViewCell: AccountCollectionViewCell? {
        return collectionViewCell as? AccountCollectionViewCell
    }
    
    override func setupCollectionViewCell() {
        super.setupCollectionViewCell()
        setContent()
        setAppearance(appearance)
    }
    
    override func unsetupCollectionViewCell() {
        super.unsetupCollectionViewCell()
    }
    
    // MARK: Content
    
    private func setContent() {
        accountCollectionViewCell?.nameLabel.text = account.name
        accountCollectionViewCell?.balanceLabel.text = "\(account.amount.description) \(account.currency.rawValue)"
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
    
    func editAccount(_ editedAccount: Account) {
        account = editedAccount
        setContent()
        setAppearance(appearance)
    }

}
}
