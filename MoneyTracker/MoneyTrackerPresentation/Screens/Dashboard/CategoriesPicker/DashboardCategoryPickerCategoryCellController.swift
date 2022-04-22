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
    
    private(set) var appearance: Appearance
    let category: Category
    
    // MARK: - View
    
    typealias CellType = DashboardScreenViewController.CategoryPickerView.CategoryCell
    var pickerItemCell: CellType? {
        return collectionViewCell as? CellType
    }
    
    // MARK: - Life cycle
    
    init(appearance: Appearance, category: Category) {
        self.appearance = appearance
        self.category = category
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    // MARK: Content
    
    private func setContent() {
        pickerItemCell?.iconView.image = UIImage(systemName: category.iconName)
        pickerItemCell?.titleLabel.text = category.name
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        pickerItemCell?.setAppearance(appearance)
    }
}
}
