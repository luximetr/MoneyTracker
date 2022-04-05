//
//  Array+Extension.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 05.04.2022.
//

import Foundation

extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
