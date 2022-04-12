//
//  Category.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationCategory = MoneyTrackerPresentation.Category
import MoneyTrackerStorage
typealias StorageCategory = MoneyTrackerStorage.Category
import MoneyTrackerUIKit

struct Category: Equatable, Hashable {
    let id: String
    let name: String
    let colorHex: String?
    let iconName: String?
    
    init(id: String, name: String, colorHex: String, iconName: String) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
    
    // MARK: PresentationCategory
    
    init(presentationCategory: PresentationCategory) throws {
        self.id = presentationCategory.id
        self.name = presentationCategory.name
        let colorConvertor = UIColorHexConvertor()
        self.colorHex = try colorConvertor.convertToHexString(color: presentationCategory.color)
        self.iconName = presentationCategory.iconName
    }
    
    func presentationCategory() throws -> PresentationCategory {
        let colorConvertor = UIColorHexConvertor()
        let color = try colorConvertor.convertToUIColor(hexString: colorHex ?? "#333333")
        let presentationCategory = PresentationCategory(id: id, name: name, color: color, iconName: iconName ?? "bag")
        return presentationCategory
    }
    
    // MARK: StorageCategory
    
    init(storageCategory: StorageCategory) {
        self.id = storageCategory.id
        self.name = storageCategory.name
        self.colorHex = storageCategory.colorHex
        self.iconName = storageCategory.iconName
    }
    
    func storageCategoty() -> StorageCategory {
        let storageCategoty = StorageCategory(id: id, name: name, colorHex: colorHex, iconName: iconName)
        return storageCategoty
    }
}
