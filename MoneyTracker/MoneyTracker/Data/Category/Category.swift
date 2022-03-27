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

struct Category: Equatable, Hashable {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: PresentationCategory
    
    init(presentationCategory: PresentationCategory) {
        self.id = presentationCategory.id
        self.name = presentationCategory.name
    }
    
    var presentationCategory: PresentationCategory {
        let presentationCategory = PresentationCategory(id: id, name: name)
        return presentationCategory
    }
    
    // MARK: StorageCategory
    
    init(storageCategory: StorageCategory) {
        self.id = storageCategory.id
        self.name = storageCategory.name
    }
    
    var storageCategoty: StorageCategory {
        let storageCategoty = StorageCategory(id: id, name: name)
        return storageCategoty
    }
}
