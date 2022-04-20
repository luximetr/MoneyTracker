//
//  ImportingCategoryAdapter.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.04.2022.
//

import Foundation

class ImportingCategoryAdapter {
    
    func adaptToAdding(importingCategory: ImportingCategory) -> AddingCategory {
        return AddingCategory(
            name: importingCategory.name,
            color: CategoryColor(rawValue: importingCategory.categoryColor ?? "") ?? .variant1,
            iconName: importingCategory.iconName ?? "bag"
        )
    }
}
