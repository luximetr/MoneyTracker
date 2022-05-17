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
        didSet { showIsSelected(isSelected) }
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
        setAppearance(appearance)
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
        pickerItemCell?.setAppearance(appearance)
        showIsSelected(isSelected)
    }
    
    private func showIsSelected(_ isSelected: Bool) {
        if isSelected {
            showCellSelected()
        } else {
            showCellDeselected()
        }
    }
    
    private func showCellSelected() {
        let categoryUIColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
        pickerItemCell?.coloredView.backgroundColor = categoryUIColor
        pickerItemCell?.coloredView.layer.borderWidth = 0
        pickerItemCell?.iconView.tintColor = appearance.categoryPrimaryText
        pickerItemCell?.titleLabel.textColor = appearance.categoryPrimaryText
    }
    
    private func showCellDeselected() {
        let categoryUIColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
        pickerItemCell?.coloredView.backgroundColor = appearance.colors.primaryBackground
        pickerItemCell?.coloredView.layer.borderWidth = 1
        pickerItemCell?.iconView.tintColor = categoryUIColor
        pickerItemCell?.titleLabel.textColor = categoryUIColor
    }
}
