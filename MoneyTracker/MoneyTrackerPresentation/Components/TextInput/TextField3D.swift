//
//  CommentTextField.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.03.2022.
//

import UIKit
import AUIKit

final class TextField3D: AUITextField {
    
    // MARK: Placeholder
    
    override var placeholder: String? {
        get {
            return attributedPlaceholder?.string
        }
        set {
            guard let string = newValue else { return }
            let attributes: [NSAttributedString.Key : Any] = [
                .font: Fonts.default(size: 17, weight: .regular),
                .foregroundColor: Colors.secondaryText
            ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            attributedPlaceholder = attributedString
        }
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        tintColor = Colors.primaryText
        textColor = Colors.primaryText
        font = Fonts.default(size: 17, weight: .regular)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.cornerRadius = 10
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
    
}
