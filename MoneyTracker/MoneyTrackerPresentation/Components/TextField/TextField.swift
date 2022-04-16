//
//  TextField.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 16.04.2022.
//

import UIKit
import AUIKit

class TextField: AUITextField {
    
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
        tintColor = appearance.primaryText
        textColor = appearance.primaryText
        backgroundColor = appearance.primaryBackground
        font = Fonts.default(size: 17, weight: .regular)
    }
    
    // MARK: - Placeholder
    
    override var placeholder: String? {
        get {
            return attributedPlaceholder?.string
        }
        set {
            guard let string = newValue else { return }
            let attributes: [NSAttributedString.Key : Any] = [
                .font: Fonts.default(size: 17, weight: .regular),
                .foregroundColor: appearance.secondaryText
            ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            attributedPlaceholder = attributedString
        }
    }
    
    // MARK: - Events
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        tintColor = appearance.primaryText
        textColor = appearance.primaryText
        backgroundColor = appearance.primaryBackground
        placeholder = placeholder
    }
    
}
