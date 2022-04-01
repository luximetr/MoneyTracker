//
//  TextButton.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 01.04.2022.
//

import Foundation
import AUIKit

final class TextButton: AUIButton {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        titleLabel?.font = Fonts.default(size: 12, weight: .regular)
        titleLabel?.textColor = Colors.accent
        setTitleColor(Colors.accent, for: .normal)
    }
    
    // MARK: States
    
    override var isHighlighted: Bool {
        willSet {
            willSetIsHighlighted(newValue)
        }
    }
    func willSetIsHighlighted(_ newValue: Bool) {
        if newValue {
            alpha = 0.6
        } else {
            alpha = 1
        }
    }
    
}
