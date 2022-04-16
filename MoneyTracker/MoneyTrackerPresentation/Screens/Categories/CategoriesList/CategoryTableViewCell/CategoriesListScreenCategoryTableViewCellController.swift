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
    
    var category: Category
    
    func editCategory(_ category: Category) {
        self.category = category
        setContent()
    }
    
    // MARK: Initializer
    
    init(category: Category) {
        self.category = category
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
        categoryTableViewCell?.nameLabel.textColor = category.color
        categoryTableViewCell?.iconView.backgroundColor = category.color
        categoryTableViewCell?.iconView.setIcon(named: category.iconName)
    }
    
}
}
