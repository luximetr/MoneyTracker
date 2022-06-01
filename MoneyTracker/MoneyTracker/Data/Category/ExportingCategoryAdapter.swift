//
//  ExportingCategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportingCategory = MoneyTrackerFiles.ExportingCategory

class ExportingCategoryAdapter {
    
    func adaptToFiles(storageCategory: StorageCategory) -> FilesExportingCategory {
        return FilesExportingCategory(
            id: storageCategory.id,
            name: storageCategory.name,
            categoryColor: (storageCategory.color).rawValue,
            iconName: storageCategory.iconName
        )
    }
}
