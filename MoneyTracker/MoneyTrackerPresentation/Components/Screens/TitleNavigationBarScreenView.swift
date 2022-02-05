//
//  TitleNavigationBarScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.02.2022.
//

import UIKit
import AUIKit

class TitleNavigationBarScreenView: NavigationBarScreenView {
    
    // MARK: Elements
    
    let titleLabel: UILabel
    
    // MARK: Initializer
    
    init(frame: CGRect = .zero, statusBarView: UIView = UIView(), navigationBarView: UIView = UIView(), titleLabel: UILabel = UILabel()) {
        self.titleLabel = titleLabel
        super.init(frame: frame, statusBarView: statusBarView, navigationBarView: navigationBarView)
    }

    // MARK: Setup
    
    override func setup() {
        super.setup()
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 24, weight: .semibold)
        titleLabel.textColor = Colors.primaryText
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
    }
    
    func layoutTitleLabel() {
        titleLabel.frame = navigationBarView.bounds
        titleLabel.textAlignment = .center
    }
    
}

