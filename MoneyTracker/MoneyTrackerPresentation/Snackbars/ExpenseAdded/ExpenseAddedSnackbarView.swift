//
//  ExpenseAddedSnackbarView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 23.03.2022.
//

import UIKit
import AUIKit

final class ExpenseAddedSnackbarView: AppearanceView {
    
    // MARK: - Subviews
    
    let messageLabel = UILabel()
    let okButton: TextButton
    
    // MARK: - Initializer
    
    override init(frame: CGRect = .zero, appearance: Appearance) {
        self.okButton = TextButton(appearance: appearance)
        super.init(frame: frame, appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addSubview(messageLabel)
        setupMessageLabel()
        addSubview(okButton)
        setupOkButton()
        setAppearance(appearance)
    }
    
    private func setupMessageLabel() {
        messageLabel.font = appearance.fonts.primary(size: 17, weight: .semibold)
        messageLabel.numberOfLines = 2
        messageLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupOkButton() {
        okButton.titleLabel?.font = appearance.fonts.primary(size: 14, weight: .semibold)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.cornerRadius = 10
        layoutOkButton()
        layoutMessageLabel()
    }
    
    private func layoutOkButton() {
        let size = okButton.sizeThatFits(bounds.size)
        let width = size.width
        let height = size.height
        let x = bounds.width - width - 24
        let y = (bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        okButton.frame = frame
    }
    
    private func layoutMessageLabel() {
        let x: CGFloat = 24
        let y: CGFloat = 14
        let width = bounds.width - x - (bounds.width - okButton.frame.origin.x) - 24
        let height = bounds.height - y * 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        messageLabel.frame = frame
    }
    
    // MARK: -Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.successActionBackground
        messageLabel.textColor = appearance.colors.successActionText
        okButton.setTitleColor(appearance.colors.successActionText, for: .normal)
    }
    
    // MARK: - Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = size.width
        let height: CGFloat = 68
        let sizeThatFits = CGSize(width: width, height: height)
        return sizeThatFits
    }
    
}
