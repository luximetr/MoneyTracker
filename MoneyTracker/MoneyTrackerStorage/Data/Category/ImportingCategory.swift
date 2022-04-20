//
//  ImportingCategory.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingCategory {
    public let name: String
    public let categoryColor: String?
    public let iconName: String?
    
    public init(name: String, categoryColor: String?, iconName: String?) {
        self.name = name
        self.categoryColor = categoryColor
        self.iconName = iconName
    }
}
