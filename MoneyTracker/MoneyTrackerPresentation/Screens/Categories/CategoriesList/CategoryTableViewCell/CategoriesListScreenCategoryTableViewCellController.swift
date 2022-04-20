//
//  CategoryTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 26.03.2022.
//

import UIKit
import AUIKit

extension CategoriesListScreenViewController {
final class CategoryTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: Data
    
    private(set) var category: Category
    private(set) var appearance: Appearance
    
    // MARK: Initializer
    
    init(category: Category, appearance: Appearance) {
        self.category = category
        self.appearance = appearance
        super.init()
    }
    
    // MARK: CategoryTableViewCell
    
    var categoryTableViewCell: CategoryTableViewCell? {
        set { view = newValue }
        get { return view as? CategoryTableViewCell }
    }

    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = super.cellForRowAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: Content
    
    private func setContent() {
        categoryTableViewCell?.nameLabel.text = category.name
        categoryTableViewCell?.iconView.setIcon(named: category.iconName)
        setAppearance(appearance)
    }
    
    func editCategory(_ category: Category) {
        self.category = category
        setContent()
    }
    
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        let categoryColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
        categoryTableViewCell?.nameLabel.textColor = categoryColor
        categoryTableViewCell?.iconView.backgroundColor = categoryColor
    }
    
}
}
