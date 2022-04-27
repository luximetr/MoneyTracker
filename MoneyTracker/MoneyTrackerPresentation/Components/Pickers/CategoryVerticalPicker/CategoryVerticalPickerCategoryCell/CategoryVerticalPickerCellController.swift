//
//  CategoryVerticalPickerCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import AUIKit

extension CategoryVerticalPickerController {
class CategoryCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    let category: Category
    
    // MARK: - Initializer
    
    init(appearance: Appearance, category: Category) {
        self.appearance = appearance
        self.category = category
    }
    
    // MARK: - Cell
    
    private typealias CategoryCell = CategoryVerticalPickerView.CategoryCell
    
    private var categoryCell: CategoryCell? {
        return tableViewCell as? CategoryCell
    }
    
    // MARK: - Create cell
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = super.cellForRowAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: - Content
    
    private func setContent() {
        categoryCell?.iconView.image = UIImage(systemName: category.iconName)
        categoryCell?.titleLabel.text = category.name
        applyAppearance(appearance)
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        applyAppearance(appearance)
    }
    
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    private func applyAppearance(_ appearance: Appearance) {
        let categoryUIColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
        categoryCell?.iconView.tintColor = categoryUIColor
        categoryCell?.titleLabel.textColor = categoryUIColor
    }
    
}
}
