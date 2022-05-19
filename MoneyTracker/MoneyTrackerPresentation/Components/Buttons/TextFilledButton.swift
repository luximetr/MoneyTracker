//
//  TextFilledButton.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.02.2022.
//

import Foundation
import AUIKit

final class TextFilledButton: AppearanceButton {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        titleLabel?.font = appearance.fonts.primary(size: 17, weight: .semibold)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
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
