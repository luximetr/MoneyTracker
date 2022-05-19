//
//  BackTitleRightButtonNavigationBarScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 19.04.2022.
//

import UIKit
import AUIKit

class BackTitleRightButtonNavigationBarScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let rightButton: UIButton
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance = LightAppearance(), statusBarView: UIView = UIView(), navigationBarView: UIView = UIView(), backButton: UIButton = PictureButton(), titleLabel: UILabel = UILabel(), rightButton: UIButton = UIButton()) {
        self.rightButton = rightButton
        super.init(frame: frame, appearance: appearance, statusBarView: statusBarView, navigationBarView: navigationBarView, backButton: backButton, titleLabel: titleLabel)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        navigationBarView.addSubview(rightButton)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAddButton()
    }
    
    private func layoutAddButton() {
        var size = navigationBarView.bounds.size
        size = rightButton.sizeThatFits(size)
        let x = navigationBarView.bounds.width - size.width - 12
        let y = (navigationBarView.frame.size.height - size.height) * 0.5
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        rightButton.frame = frame
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        rightButton.setTitleColor(appearance.colors.accent, for: .normal)
    }
}
