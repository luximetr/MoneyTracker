//
//  EditingCategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 08.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage
import UIKit
import MoneyTrackerUIKit

typealias PresentationEditingCategory = MoneyTrackerPresentation.EditingCategory
typealias StorageEditingCategory = MoneyTrackerStorage.EditingCategory

class EditingCategoryAdapter {
    
    private let colorConvertor = UIColorHexConvertor()
    private let categoryColorAdapter = CategoryColorAdapter()
    
    func adaptToStorage(presentationEditingCategory: PresentationEditingCategory) throws -> StorageEditingCategory {
        return StorageEditingCategory(
            id: presentationEditingCategory.id,
            name: presentationEditingCategory.name,
            color: categoryColorAdapter.adaptToStorageOptional(presentationCategoryColor: presentationEditingCategory.color),
            iconName: presentationEditingCategory.iconName
        )
    }
    
    private func convertToColorHex(uiColor: UIColor?) throws -> String? {
        guard let uiColor = uiColor else { return nil }
        return try colorConvertor.convertToHexString(color: uiColor)
    }
}
