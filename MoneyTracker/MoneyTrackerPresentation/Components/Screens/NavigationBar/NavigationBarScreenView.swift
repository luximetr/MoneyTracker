//
//  NavigationBarScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

class NavigationBarScreenView: StatusBarScreenView {
    
    // MARK: - Elements
    
    let navigationBarView: UIView
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance, statusBarView: UIView = UIView(), navigationBarView: UIView = UIView()) {
        self.navigationBarView = navigationBarView
        super.init(frame: frame, appearance: appearance, statusBarView: statusBarView)
    }

    // MARK: - Setup
    
    override func setup() {
        super.setup()
        insertSubview(navigationBarView, belowSubview: statusBarView)
        setupNavigationBarView()
    }
    
    func setupNavigationBarView() {
        navigationBarView.backgroundColor = appearance.primaryBackground
        navigationBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        navigationBarView.layer.shadowOpacity = 0.6
        navigationBarView.layer.shadowRadius = 12
        navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 12)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNavigationBarView()
    }
    
    func layoutNavigationBarView() {
        let x: CGFloat = 0
        let y = statusBarView.frame.origin.y + statusBarView.frame.size.height
        let width = bounds.width
        let height: CGFloat = 48
        navigationBarView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - Events
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        setupNavigationBarView()
    }
    
}

