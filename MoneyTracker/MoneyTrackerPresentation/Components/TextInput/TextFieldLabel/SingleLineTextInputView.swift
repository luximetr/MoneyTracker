//
//  SingleLineTextInputView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 18.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class SingleLineTextInputView: AppearanceView, TextFieldLabelView {
    
    // MARK: - Subviews
    
    let textField = UITextField()
    let label = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(textField)
        addSubview(label)
        setupSelf()
        setupTextField()
        setupLabel()
        changeAppearance(appearance)
    }
    
    private func setupSelf() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }
    
    private func setupTextField() {
        textField.font = appearance.fonts.primary(size: 17, weight: .regular)
    }
    
    private func setupLabel() {
        label.numberOfLines = 1
        label.font = appearance.fonts.primary(size: 14, weight: .regular)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLabel()
        layoutTextField()
    }
    
    private func layoutLabel() {
        label.pin
            .right(10)
            .vCenter()
            .sizeToFit()
    }
        
    private func layoutTextField() {
        textField.pin
            .left(16)
            .top()
            .bottom()
            .right(to: label.edge.left).marginRight(5)
    }
    
    // MARK: - TextField - Placeholder
    
    var placeholder: String? {
        get {
            return textField.attributedPlaceholder?.string
        }
        set {
            guard let string = newValue else { return }
            let attributes: [NSAttributedString.Key : Any] = [
                .font: appearance.fonts.primary(size: 17, weight: .regular),
                .foregroundColor: appearance.tertiaryText
            ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            textField.attributedPlaceholder = attributedString
        }
    }

    // MARK: - TextFieldLabelView
    
    var textFieldLabelViewTextField: UITextField {
        return textField
    }
    
    var textFieldLabelViewLabel: UILabel {
        return label
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        layer.borderColor = appearance.colors.secondaryBackground.cgColor
        textField.tintColor = appearance.accent
        textField.textColor = appearance.primaryText
        textField.backgroundColor = appearance.colors.primaryBackground
        textField.layer.borderColor = appearance.colors.secondaryBackground.cgColor
        label.textColor = appearance.secondaryText
        placeholder = placeholder
    }
}
