//
//  SingleLineTextInputView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 18.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class SingleLineTextInputView: AUIView, TextFieldLabelView {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(textField)
        addSubview(label)
        setupSelf()
        setupTextField()
        setupLabel()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLabel()
        layoutTextField()
    }
    
    // MARK: - Self
    
    private func setupSelf() {
        backgroundColor = Colors.white
        layer.cornerRadius = 10
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
    
    // MARK: - TextField
    
    let textField = UITextField()
    
    private func setupTextField() {
        textField.textColor = Colors.primaryText
        
    }
    
    private func layoutTextField() {
        textField.pin
            .left().marginLeft(16)
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
                .foregroundColor: Colors.secondaryText
            ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            textField.attributedPlaceholder = attributedString
        }
    }
    
    // MARK: - Label
    
    let label = UILabel()
    
    private func setupLabel() {
        label.numberOfLines = 1
        label.textColor = Colors.secondaryText
        label.font = Fonts.default(size: 14, weight: .regular)
    }
    
    private func layoutLabel() {
        label.pin
            .right(10)
            .vCenter()
            .sizeToFit()
    }
    
    // MARK: - TextFieldLabelView
    
    var textFieldLabelViewTextField: UITextField {
        return textField
    }
    
    var textFieldLabelViewLabel: UILabel {
        return label
    }
}
