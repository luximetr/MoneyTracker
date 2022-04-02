//
//  CategoryHorizontalPickerItemCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class CategoryHorizontalPickerItemCellController: AUIClosuresCollectionViewCellController {
    
    let category: Category
    
    var isSelected: Bool {
        didSet { pickerItemCell?.update(isSelected: isSelected) }
    }
    
    // MARK: - View
    
    var pickerItemCell: CategoryHorizontalPickerItemCell? {
        return collectionViewCell as? CategoryHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(category: Category, isSelected: Bool) {
        self.category = category
        self.isSelected = isSelected
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: Content
    
    private func setContent() {
        pickerItemCell?.titleLabel.text = category.name
        pickerItemCell?.update(isSelected: isSelected)
    }
}
