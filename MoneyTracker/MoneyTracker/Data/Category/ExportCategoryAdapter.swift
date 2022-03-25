//
//  ExportCategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportCategory = MoneyTrackerFiles.ExportCategory

class ExportCategoryAdapter {
    
    func adaptToFiles(storageCategory: StorageCategory) -> FilesExportCategory {
        return FilesExportCategory(
            id: storageCategory.id,
            name: storageCategory.name
        )
    }
}
