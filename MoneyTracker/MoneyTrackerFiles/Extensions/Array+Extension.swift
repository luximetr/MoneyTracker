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
