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
    
    let accountId: AccountId
    
    var isSelected: Bool {
        didSet { pickerItemCell?.update(isSelected: isSelected) }
    }
    
    // MARK: - View
    
    var pickerItemCell: BalanceAccountHorizontalPickerItemCell? {
        return collectionViewCell as? BalanceAccountHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(accountId: AccountId, isSelected: Bool) {
        self.accountId = accountId
        self.isSelected = isSelected
    }
}
