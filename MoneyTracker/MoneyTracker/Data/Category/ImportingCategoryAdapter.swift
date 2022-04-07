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
            colorHex: filesImportingCategory.colorHex ?? "#333333",
            iconName: filesImportingCategory.iconName ?? "bag"
        )
    }
    
    func adaptToStorage(filesImportingCategory: FilesImportingCategory) -> StorageImportingCategory {
        return StorageImportingCategory(
            name: filesImportingCategory.name,
            colorHex: filesImportingCategory.colorHex,
            iconName: filesImportingCategory.iconName
        )
    }
}
