//
//  AddingCategory.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAddingCategory = MoneyTrackerPresentation.AddingCategory
import MoneyTrackerStorage
typealias StorageAddingCategory = MoneyTrackerStorage.AddingCategory
import MoneyTrackerUIKit

struct AddingCategory: Equatable, Hashable {
    let name: String
    let colorHex: String
    let iconName: String
    
    init(name: String, colorHex: String, iconName: String) {
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
    
    // MARK: PresentationAddingCategory
    
    init(presentationAddingCategory: PresentationAddingCategory) throws {
        self.name = presentationAddingCategory.name
        let colorConvertor = UIColorHexConvertor()
        self.colorHex = "#333333"// try colorConvertor.convertToHexString(color: presentationAddingCategory.color)
        self.iconName = presentationAddingCategory.iconName
    }
    
    func presentationAddingCategory() throws -> PresentationAddingCategory {
        let colorConvertor = UIColorHexConvertor()
        let color = CategoryColor.variant1// try colorConvertor.convertToUIColor(hexString: colorHex)
        let presentationAddingCategory = PresentationAddingCategory(name: name, color: color, iconName: iconName)
        return presentationAddingCategory
    }
    
    // MARK: StorageCategory
    
    init(storageAddingCategoty: StorageAddingCategory) {
        self.name = storageAddingCategoty.name
        self.colorHex = storageAddingCategoty.colorHex
        self.iconName = storageAddingCategoty.iconName
    }
    
    func storageAddingCategoty() -> StorageAddingCategory {
        let storageAddingCategoty = StorageAddingCategory(name: name, colorHex: colorHex, iconName: iconName)
        return storageAddingCategoty
    }
}
