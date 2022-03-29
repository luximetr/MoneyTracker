//
//  CategoryHorizontalPickerItemCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class CategoryHorizontalPickerItemCellController: AUIClosuresCollectionViewCellController {
    
    let categoryId: CategoryId
    
    var isSelected: Bool {
        didSet { pickerItemCell?.update(isSelected: isSelected) }
    }
    
    // MARK: - View
    
    var pickerItemCell: CategoryHorizontalPickerItemCell? {
        return collectionViewCell as? CategoryHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(categoryId: CategoryId, isSelected: Bool) {
        self.categoryId = categoryId
        self.isSelected = isSelected
    }
}
