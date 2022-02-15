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
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
