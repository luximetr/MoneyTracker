//
//  DashboardCategoryPickerCategoryCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 06.04.2022.
//

import AUIKit
import UIKit

extension DashboardScreenViewController.CategoryPickerViewController {
final class CategoryCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: - Data
    
    let category: Category
    
    // MARK: - View
    
    var pickerItemCell: CategoryHorizontalPickerItemCell? {
        return collectionViewCell as? CategoryHorizontalPickerItemCell
    }
    
    // MARK: - Life cycle
    
    init(category: Category) {
        self.category = category
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: Content
    
    private func setContent() {
        pickerItemCell?.iconView.tintColor = Colors.secondaryText
        pickerItemCell?.iconView.image = UIImage(systemName: category.iconName)
        pickerItemCell?.titleLabel.text = category.name
        pickerItemCell?.titleLabel.textColor = Colors.secondaryText
        pickerItemCell?.update(isSelected: false)
    }
}
}
