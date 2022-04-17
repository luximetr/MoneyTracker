//
//  AppearanceButton.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 16.04.2022.
//

import UIKit
import AUIKit

class AppearanceButton: AUIButton {
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance) {
        self.appearance = appearance
        super.init(frame: frame)
    }
    
    // MARK: - Appearance
    
    var appearance: Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
    }
    
}
