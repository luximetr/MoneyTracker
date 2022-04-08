//
//  Category.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation

public struct Category: Equatable, Hashable {
    public let id: String
    public let name: String
    public let colorHex: String?
    public let iconName: String?
    
    public init(id: String, name: String, colorHex: String?, iconName: String?) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
}

typealias CategoryId = String
