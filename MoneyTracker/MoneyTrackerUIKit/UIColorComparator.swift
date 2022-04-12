//
//  UIColorComparator.swift
//  MoneyTrackerUIKit
//
//  Created by Job Ihor Myroniuk on 12.04.2022.
//

import UIKit

open class UIColorComparator {
    
    // MARK: Initializer
    
    public init() {
        
    }
    
    private let colorConvertor = UIColorHexConvertor()
    
    open func findIsColorsEquals(_ lhs: UIColor, _ rhs: UIColor) -> Bool {
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
