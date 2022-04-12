//
//  Array+Extension.swift
//  MoneyTrackerFoundation
//
//  Created by Job Ihor Myroniuk on 12.04.2022.
//

import Foundation

public extension Array where Element: Equatable {

    func findIndex(of element: Element, skipFirst: Int) -> Array.Index? {
        if skipFirst == 0 {
            return self.firstIndex(of: element)
        } else {
            var indexes: [Array.Index] = []
            for (index, arrayElement) in self.enumerated() {
                if arrayElement == element {
                    indexes.append(index)
                }
            }
            return indexes[safe: skipFirst]
        }
    }
}
