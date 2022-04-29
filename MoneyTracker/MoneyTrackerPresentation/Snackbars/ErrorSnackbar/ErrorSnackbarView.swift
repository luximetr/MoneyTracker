//
//  ErrorSnackbarView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 29.04.2022.
//

import UIKit
import PinLayout

class ErrorSnackbarView: AppearanceView {
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    let dismissButton = UIButton()
    let dismissIcon = UIImageView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupSelf()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(dismissIcon)
        setupDismissIcon()
        addSubview(dismissButton)
        changeAppearance(appearance)
    }
    
    private func setupSelf() {
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.cornerRadius = 10
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = Fonts.default(size: 17, weight: .semibold)
        titleLabel.text = "Error and long text and long text and long text and long text and long text and long text"
    }
    
    private func setupDismissIcon() {
        dismissIcon.image = Images.close
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutDismissIcon()
        layoutDismissButton()
        layoutTitleLabel()
    }
    
    private let dismissIconWidth: CGFloat = 14
    private let dismissIconTrailing: CGFloat = 24
    
    private func layoutDismissIcon() {
        dismissIcon.pin
            .height(14)
            .width(dismissIconWidth)
            .vCenter()
            .right(dismissIconTrailing)
    }
    
    private func layoutDismissButton() {
        dismissButton.pin
            .vCenter(to: dismissIcon.edge.vCenter)
            .hCenter(to: dismissIcon.edge.hCenter)
            .height(20)
            .width(20)
    }
    
    private let titleLabelLeading: CGFloat = 24
    private let titleLabelTrailing: CGFloat = 24
    private let titleLabelTop: CGFloat = 15
    private let titleLabelBottom: CGFloat = 15
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .left(titleLabelLeading)
            .right(to: dismissIcon.edge.left).marginRight(titleLabelTrailing)
            .top(titleLabelTop)
            .bottom(titleLabelBottom)
    }
    
    // MARK: - Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = size.width
        let titleLabelAvailableWidth = size.width - (dismissIconWidth + dismissIconTrailing + titleLabelLeading + titleLabelTrailing)
        let titleLabelAvailableHeight = size.height - (titleLabelTop + titleLabelBottom)
        let titleLabelAvailableSize = CGSize(width: titleLabelAvailableWidth, height: titleLabelAvailableHeight)
        let titleLabelTakenSize = titleLabel.sizeThatFits(titleLabelAvailableSize)
        let height: CGFloat = titleLabelTakenSize.height + titleLabelTop + titleLabelBottom
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.dangerousActionBackground
        titleLabel.textColor = appearance.dangerousActionText
        dismissIcon.tintColor = appearance.dangerousActionText
    }
}
