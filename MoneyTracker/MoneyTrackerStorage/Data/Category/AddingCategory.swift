//
//  AddingCategory.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import Foundation

public struct AddingCategory: Equatable, Hashable {
    public let name: String
    public let colorHex: String
    public let iconName: String
    
    public init(name: String, colorHex: String, iconName: String) {
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
}
