//
//  TitleNavigationBarScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.02.2022.
//

import UIKit
import AUIKit

class TitleNavigationBarScreenView: NavigationBarScreenView {
    
    // MARK: - Elements
    
    let titleLabel: UILabel
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance = LightAppearance(), statusBarView: UIView = UIView(), navigationBarView: UIView = UIView(), titleLabel: UILabel = UILabel()) {
        self.titleLabel = titleLabel
        super.init(frame: frame, appearance: appearance, statusBarView: statusBarView, navigationBarView: navigationBarView)
    }

    // MARK: - Setup
    
    override func setup() {
        super.setup()
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.font = appearance.fonts.primary(size: 24, weight: .semibold)
        titleLabel.textColor = appearance.colors.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
    }
    
    func layoutTitleLabel() {
        titleLabel.frame = navigationBarView.bounds
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Events
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        setupTitleLabel()
    }
    
}

