//
//  TextButton.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 01.04.2022.
//

import UIKit
import AUIKit

final class TextButton: AppearanceButton {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        titleLabel?.font = appearance.fonts.primary(size: 12, weight: .regular)
        titleLabel?.textColor = appearance.accent
        setTitleColor(appearance.accent, for: .normal)
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
