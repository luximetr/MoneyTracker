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
    private(set) var appearance: Appearance
    
    var isSelected: Bool {
        didSet { pickerItemCell?.update(isSelected: isSelected) }
    }
    
    // MARK: - View
    
    var pickerItemCell: CategoryHorizontalPickerItemCell? {
        return collectionViewCell as? CategoryHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(category: Category, isSelected: Bool, appearance: Appearance) {
        self.category = category
        self.isSelected = isSelected
        self.appearance = appearance
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: Content
    
    private var uiColorProvider = CategoryColorUIColorProvider()
    
    private func setContent() {
        pickerItemCell?.iconView.image = UIImage(systemName: category.iconName)
        pickerItemCell?.titleLabel.text = category.name
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        let categoryUIColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
        pickerItemCell?.iconView.tintColor = categoryUIColor
        pickerItemCell?.titleLabel.textColor = categoryUIColor
        pickerItemCell?.update(isSelected: isSelected)
    }
}
