//
//  CategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 20.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationCategory = MoneyTrackerPresentation.Category
typealias StorageCategory = MoneyTrackerStorage.Category

class CategoryAdapter {
    
    private let categoryColorAdapter = CategoryColorAdapter()
    
    func adaptToStorage(presentationCategory: PresentationCategory) -> StorageCategory {
        return StorageCategory(
            id: presentationCategory.id,
            name: presentationCategory.name,
            color: categoryColorAdapter.adaptToStorage(presentationCategoryColor: presentationCategory.color),
            iconName: presentationCategory.iconName
        )
    }
    
    func adaptToPresentation(storageCategory: StorageCategory) -> PresentationCategory {
        return PresentationCategory(
            id: storageCategory.id,
            name: storageCategory.name,
            color: categoryColorAdapter.adaptToPresentationOptional(storageCategoryColor: storageCategory.color) ?? .variant1,
            iconName: storageCategory.iconName
        )
    }
    
}
