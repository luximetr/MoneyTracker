//
//  AddingCategory.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import Foundation
import UIKit

public struct AddingCategory: Equatable, Hashable {
    public let name: String
    public let color: CategoryColor
    public let iconName: String
    
    public init(name: String, color: CategoryColor, iconName: String) {
        self.name = name
        self.color = color
        self.iconName = iconName
    }
}
