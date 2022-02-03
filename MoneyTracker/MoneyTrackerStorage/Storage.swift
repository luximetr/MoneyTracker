//
//  Storage.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation

public class Storage {
    
    // MARK: Initiaizer
    
    public init() {
        
    }
    
    // MARK: Categories
    
    private var _categories: [Category] = [
        Category(id: UUID().uuidString, name: "Category 1"),
        Category(id: UUID().uuidString, name: "Category 2"),
        Category(id: UUID().uuidString, name: "Category 3"),
        Category(id: UUID().uuidString, name: "Category 4"),
    ]
    
    public func categories() -> [Category] {
        return _categories
    }
    
    public func addCategory(_ addingCategory: AddingCategory) {
        let category = Category(id: UUID().uuidString, name: addingCategory.name)
        _categories.append(category)
    }
    
}
