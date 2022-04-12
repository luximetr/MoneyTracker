//
//  Array+Extension.swift
//  MoneyTrackerFoundation
//
//  Created by Job Ihor Myroniuk on 12.04.2022.
//

import Foundation

public extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    var isNonEmpty: Bool {
        return !isEmpty
    }
    
}
