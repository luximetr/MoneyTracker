//
//  View.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 16.04.2022.
//

import UIKit
import AUIKit

class View: AUIView {
    
    // MARK: - Appearance
    
    var appearance: Appearance
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance = LightAppearance()) {
        self.appearance = appearance
        super.init(frame: frame)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
    }
        
    // MARK: - Events
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        backgroundColor = appearance.primaryBackground
    }
    
}
