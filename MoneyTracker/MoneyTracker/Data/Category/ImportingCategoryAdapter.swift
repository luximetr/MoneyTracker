//
//  ImportingCategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesImportingCategory = MoneyTrackerFiles.ImportingCategory
typealias StorageImportingCategory = MoneyTrackerStorage.ImportingCategory

class ImportingCategoryAdapter {
    
    func adaptToStorageAdding(filesImportingCategory: FilesImportingCategory) -> StorageAddingCategory {
        return StorageAddingCategory(
            name: filesImportingCategory.name,
            color: CategoryColor(rawValue: filesImportingCategory.categoryColor ?? "") ?? .variant1,
            iconName: filesImportingCategory.iconName ?? "bag"
        )
    }
    
    func adaptToStorage(filesImportingCategory: FilesImportingCategory) -> StorageImportingCategory {
        return StorageImportingCategory(
            name: filesImportingCategory.name,
            categoryColor: filesImportingCategory.categoryColor,
            iconName: filesImportingCategory.iconName
        )
    }
}
