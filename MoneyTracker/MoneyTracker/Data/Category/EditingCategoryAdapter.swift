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
    
    func adaptToStorage(presentationEditingCategory: PresentationEditingCategory) throws -> StorageEditingCategory {
        let colorHex = try convertToColorHex(uiColor: presentationEditingCategory.color)
        return StorageEditingCategory(
            id: presentationEditingCategory.id,
            name: presentationEditingCategory.name,
            colorHex: colorHex,
            iconName: presentationEditingCategory.iconName
        )
    }
    
    private func convertToColorHex(uiColor: UIColor?) throws -> String? {
        guard let uiColor = uiColor else { return nil }
        return try colorConvertor.convertToHexString(color: uiColor)
    }
}
