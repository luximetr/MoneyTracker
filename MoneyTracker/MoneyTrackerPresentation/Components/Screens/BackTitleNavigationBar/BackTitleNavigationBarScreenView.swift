//
//  BackTitleNavigationBarScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

class BackTitleNavigationBarScreenView: NavigationBarScreenView {
    
    // MARK: - Elements
    
    let backButton: UIButton
    let titleLabel: UILabel
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance = LightAppearance(), statusBarView: UIView = UIView(), navigationBarView: UIView = UIView(), backButton: UIButton = PictureButton(), titleLabel: UILabel = UILabel()) {
        self.backButton = backButton
        self.titleLabel = titleLabel
        super.init(frame: frame, appearance: appearance, statusBarView: statusBarView, navigationBarView: navigationBarView)
    }

    // MARK: - Setup
    
    override func setup() {
        super.setup()
        navigationBarView.addSubview(backButton)
        setupBackButton()
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    func setupBackButton() {
        backButton.setImage(Images.backArrow.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.imageView?.tintColor = appearance.accent
    }
    
    func setupTitleLabel() {
        titleLabel.font = appearance.fonts.primary(size: 24, weight: .semibold)
        titleLabel.textColor = appearance.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBackButton()
        layoutTitleLabel()
    }
    
    func layoutBackButton() {
        let x: CGFloat = 12
        let y: CGFloat = 8
        let width: CGFloat = 18
        let height: CGFloat = 24
        let frame = CGRect(x: x, y: y, width: width, height: height)
        backButton.frame = frame
    }
    
    func layoutTitleLabel() {
        let x = backButton.frame.origin.x + backButton.frame.size.width + 8
        let y: CGFloat = 0
        let width: CGFloat = navigationBarView.frame.width - 2 * x
        let height: CGFloat = navigationBarView.frame.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Events
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        setupBackButton()
        setupTitleLabel()
    }
    
}

