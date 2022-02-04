//
//  AddingCategory.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import Foundation

public struct AddingCategory: Equatable, Hashable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
