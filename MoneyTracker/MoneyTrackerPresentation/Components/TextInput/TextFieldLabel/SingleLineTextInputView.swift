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
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.textField = PlainTextField(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let textField: PlainTextField
    let label = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(textField)
        addSubview(label)
        setupSelf()
        setupTextField()
        setupLabel()
    }
    
    private func setupSelf() {
        backgroundColor = appearance.primaryBackground
        layer.cornerRadius = 10
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
    
    private func setupLabel() {
        label.numberOfLines = 1
        label.textColor = appearance.secondaryText
        label.font = Fonts.default(size: 14, weight: .regular)
    }
    
    private func setupTextField() {
        textField.textColor = appearance.primaryText
        
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
            .left()
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
                .font: Fonts.default(size: 17, weight: .regular),
                .foregroundColor: appearance.secondaryText
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
        setupSelf()
        setupLabel()
        setupTextField()
    }
}
