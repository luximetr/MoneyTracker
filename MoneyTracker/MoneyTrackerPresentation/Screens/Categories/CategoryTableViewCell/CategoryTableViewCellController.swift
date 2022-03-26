//
//  CategoryTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 26.03.2022.
//

import UIKit
import AUIKit

extension CategoriesScreenViewController {
final class CategoryTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: Data
    
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init()
    }

}
}
