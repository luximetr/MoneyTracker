//
//  UIColorComparator.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 05.04.2022.
//

import UIKit

class UIColorComparator {
    
    private let colorConvertor = UIColorHexConvertor()
    
    func findIsColorsEquals(_ lhs: UIColor, _ rhs: UIColor) -> Bool {
        do {
            let lhsHex = try colorConvertor.convertToHexString(color: lhs)
            let rhsHex = try colorConvertor.convertToHexString(color: rhs)
            return lhsHex == rhsHex
        } catch {
            print(error)
            return false
        }
    }
}
