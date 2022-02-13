//
//  MoneySumTextInputValidator.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.02.2022.
//

import UIKit
import AUIKit

class MoneySumTextInputValidator: AUITextInputValidator {
    
    func validate(textInput: String?) -> Bool {
        guard let textInput = textInput else { return true }
        let decimalSeparator: String?
        let decimalSeparatorDot = "."
        let decimalSeparatorComma = ","
        if textInput.contains(decimalSeparatorDot) {
            decimalSeparator = decimalSeparatorDot
        } else if textInput.contains(decimalSeparatorComma) {
            decimalSeparator = decimalSeparatorComma
        } else {
            decimalSeparator = nil
        }
        
        let zeroDigitString = "0"
        let decimalDigitsCharacterSet = CharacterSet.decimalDigits
        if let decimalSeparator = decimalSeparator {
            let components = textInput.components(separatedBy: decimalSeparator)
            if components.count == 2, let beforeDecimalSeparator = components.first, let afterDecimalSeparator = components.last {
                let beforeDecimalSeparatorCharacterSet = CharacterSet(charactersIn: beforeDecimalSeparator)
                guard beforeDecimalSeparatorCharacterSet.isSubset(of: decimalDigitsCharacterSet) else { return false }
                guard !beforeDecimalSeparator.starts(with: zeroDigitString) else { return false }
                let afterDecimalSeparatorCharacterSet = CharacterSet(charactersIn: afterDecimalSeparator)
                guard afterDecimalSeparatorCharacterSet.isSubset(of: decimalDigitsCharacterSet) else { return false }
                guard afterDecimalSeparator.count <= 2 else { return false }
                return true
            } else if components.count == 1 {
                guard !textInput.starts(with: zeroDigitString) else { return false }
                return true
            } else {
                return false
            }
        } else {
            let textInputCharacterSet = CharacterSet(charactersIn: textInput)
            guard textInputCharacterSet.isSubset(of: decimalDigitsCharacterSet) else { return false }
            guard !textInput.starts(with: zeroDigitString) else { return false }
            return true
        }
    }
    
}
