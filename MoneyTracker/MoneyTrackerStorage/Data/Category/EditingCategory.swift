//
//  EditingCategory.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct EditingCategory: Equatable, Hashable {
    public let id: String
    public let name: String
    public let color: CategoryColor
    public let iconName: String
    
    public init(id: String, name: String, color: CategoryColor, iconName: String) {
        self.id = id
        self.name = name
        self.color = color
        self.iconName = iconName
    }
}
