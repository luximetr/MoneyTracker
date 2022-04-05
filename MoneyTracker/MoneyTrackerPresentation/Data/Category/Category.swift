//
//  Category.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation
import UIKit

public struct Category: Equatable, Hashable {
    public let id: String
    public let name: String
    public let color: UIColor
    public let iconName: String
    
    public init(id: String, name: String, color: UIColor, iconName: String) {
        self.id = id
        self.name = name
        self.color = color
        self.iconName = iconName
    }
}

typealias CategoryId = String
