//
//  PlainTextField.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.03.2022.
//

import UIKit
import AUIKit

final class PlainTextField: TextField {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupBorder()
    }
    
    func setupBorder() {
        layer.borderColor = appearance.secondaryBackground.cgColor
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x = 16
        textRect.size.width -= 16 * 2
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x = 16
        editingRect.size.width -= 16 * 2
        return editingRect
    }
    
    // MARK: - Events
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        setupBorder()
    }
    
}
