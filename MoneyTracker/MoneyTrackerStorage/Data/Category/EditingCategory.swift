//
//  EditingCategory.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct EditingCategory: Equatable, Hashable {
    public let name: String?
    public let colorHex: String?
    public let iconName: String?
    
    public init(name: String? = nil, colorHex: String? = nil, iconName: String? = nil) {
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
}
