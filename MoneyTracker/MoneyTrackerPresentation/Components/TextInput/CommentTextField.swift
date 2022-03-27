//
//  CommentTextField.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.03.2022.
//

import UIKit
import AUIKit

final class CommentTextField: AUITextField {
    
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
        backgroundColor = Colors.secondaryBackground
        clipsToBounds = true
        tintColor = Colors.primaryText
        textColor = Colors.primaryText
        font = Fonts.default(size: 17, weight: .regular)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
