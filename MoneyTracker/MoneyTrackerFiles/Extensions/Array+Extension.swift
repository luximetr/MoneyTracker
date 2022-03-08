//
//  Array+Extension.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 28.02.2022.
//

import Foundation

extension Array {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Equatable {

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
