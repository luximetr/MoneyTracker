//
//  ExportingCategory.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

public struct ExportingCategory {
    public let id: String
    public let name: String
    public let categoryColor: String
    public let iconName: String
    
    public init(id: String, name: String, categoryColor: String, iconName: String) {
        self.id = id
        self.name = name
        self.categoryColor = categoryColor
        self.iconName = iconName
    }
}
