//
//  BalanceAccountHorizontalPickerItemCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class BalanceAccountHorizontalPickerItemCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: - Data
    
    let account: Account
    private(set) var appearance: Appearance
    
    var isSelected: Bool {
        didSet { pickerItemCell?.update(isSelected: isSelected) }
    }
    
    // MARK: - View
    
    var pickerItemCell: BalanceAccountHorizontalPickerItemCell? {
        return collectionViewCell as? BalanceAccountHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(account: Account, isSelected: Bool, appearance: Appearance) {
        self.account = account
        self.isSelected = isSelected
        self.appearance = appearance
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        setAppearance(appearance)
        return cell
    }
    
    // MARK: Content
    
    private func setContent() {
        pickerItemCell?.titleLabel.text = account.name
    }
    
    // MARK: - Appearance
    
    private let uiColorProvider = AccountColorUIColorProvider()
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        let accountUIColor = uiColorProvider.getUIColor(accountColor: account.color, appearance: appearance)
        pickerItemCell?.setColor(accountUIColor)
        pickerItemCell?.update(isSelected: isSelected)
    }
}
