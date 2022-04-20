//
//  AddingCategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 20.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationAddingCategory = MoneyTrackerPresentation.AddingCategory
typealias StorageAddingCategory = MoneyTrackerStorage.AddingCategory

class AddingCategoryAdapter {
    
    private let categoryColorAdapter = CategoryColorAdapter()
    
    func adaptToStorage(presentationAddingCategory: PresentationAddingCategory) -> StorageAddingCategory {
        return StorageAddingCategory(
            name: presentationAddingCategory.name,
            color: categoryColorAdapter.adaptToStorage(presentationCategoryColor: presentationAddingCategory.color),
            iconName: presentationAddingCategory.iconName
        )
    }
    
    func adaptToPresentation(storageAddingCategory: StorageAddingCategory) -> PresentationAddingCategory {
        return PresentationAddingCategory(
            name: storageAddingCategory.name,
            color: categoryColorAdapter.adaptToPresentation(storageCategoryColor: storageAddingCategory.color),
            iconName: storageAddingCategory.iconName
        )
    }
    
}
