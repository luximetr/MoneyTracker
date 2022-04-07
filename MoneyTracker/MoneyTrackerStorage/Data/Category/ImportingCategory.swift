//
//  ImportingCategory.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingCategory {
    public let name: String
    public let colorHex: String?
    public let iconName: String?
    
    public init(name: String, colorHex: String?, iconName: String?) {
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
}
