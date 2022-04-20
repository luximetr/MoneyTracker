//
//  Category.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation

public struct Category: Equatable, Hashable {
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

typealias CategoryId = String
