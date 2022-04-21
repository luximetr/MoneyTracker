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
    
    var isSelected: Bool {
        didSet { pickerItemCell?.update(isSelected: isSelected) }
    }
    
    // MARK: - View
    
    var pickerItemCell: BalanceAccountHorizontalPickerItemCell? {
        return collectionViewCell as? BalanceAccountHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(account: Account, isSelected: Bool) {
        self.account = account
        self.isSelected = isSelected
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: Content
    
    private func setContent() {
        pickerItemCell?.titleLabel.text = account.name
//        pickerItemCell?.color = account.backgroundColor
        pickerItemCell?.update(isSelected: isSelected)
    }
    
}
