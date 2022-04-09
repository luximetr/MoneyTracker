//
//  EditingCategory.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.04.2022.
//

import Foundation
import UIKit

public struct EditingCategory: Equatable, Hashable {
    public let id: String
    public let name: String?
    public let color: UIColor?
    public let iconName: String?
    
    public init(id: String, name: String?, color: UIColor?, iconName: String?) {
        self.id = id
        self.name = name
        self.color = color
        self.iconName = iconName
    }
}
