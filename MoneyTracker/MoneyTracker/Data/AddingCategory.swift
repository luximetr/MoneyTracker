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

struct AddingCategory: Equatable, Hashable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    // MARK: PresentationAddingCategory
    
    init(presentationAddingCategory: PresentationAddingCategory) {
        self.name = presentationAddingCategory.name
    }
    
    var presentationAddingCategory: PresentationAddingCategory {
        let presentationAddingCategory = PresentationAddingCategory(name: name)
        return presentationAddingCategory
    }
    
    // MARK: StorageCategory
    
    init(storageAddingCategoty: StorageAddingCategory) {
        self.name = storageAddingCategoty.name
    }
    
    var storageAddingCategoty: StorageAddingCategory {
        let storageAddingCategoty = StorageAddingCategory(name: name)
        return storageAddingCategoty
    }
}
