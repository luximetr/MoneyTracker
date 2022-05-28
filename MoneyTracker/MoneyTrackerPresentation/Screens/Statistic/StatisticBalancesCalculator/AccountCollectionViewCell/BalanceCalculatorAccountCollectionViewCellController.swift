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
    private var isSelected: Bool
    private let fundsAmountNumberFormatter: NumberFormatter
    
    // MARK: Initializer
        
    init(account: Account, appearance: Appearance, isSelected: Bool, fundsAmountNumberFormatter: NumberFormatter) {
        self.account = account
        self.appearance = appearance
        self.isSelected = isSelected
        self.fundsAmountNumberFormatter = fundsAmountNumberFormatter
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
    
    // MARK: Content
    
    func setIsSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        accountCollectionViewCell?.setSelected(isSelected)
    }
    
    private func setContent() {
        accountCollectionViewCell?.color = uiColorProvider.getUIColor(accountColor: account.color, appearance: appearance)
        accountCollectionViewCell?.setSelected(isSelected)
        accountCollectionViewCell?.nameLabel.text = account.name
        let fundsString = fundsAmountNumberFormatter.string(from: account.amount as NSNumber) ?? ""
        accountCollectionViewCell?.balanceLabel.text = "\(fundsString) \(account.currency.rawValue)"
        accountCollectionViewCell?.setNeedsLayout()
        accountCollectionViewCell?.layoutIfNeeded()
    }
    
    // MARK: - Appearance
    
    private let uiColorProvider = AccountColorUIColorProvider()
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        let accountUIColor = uiColorProvider.getUIColor(accountColor: account.color, appearance: appearance)
        accountCollectionViewCell?.setColor(accountUIColor)
    }
    
    // MARK: Events
    
    func editAccount(_ editedAccount: Account) {
        account = editedAccount
        setContent()
        setAppearance(appearance)
    }

}
}
