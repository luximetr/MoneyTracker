//
//  PictureButton.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import Foundation
import AUIKit

final class PictureButton: AUIButton {
    
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
