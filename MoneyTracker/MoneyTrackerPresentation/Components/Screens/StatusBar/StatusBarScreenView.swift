//
//  StatusBarScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit
import AUIKit

class StatusBarScreenView: AUIStatusBarScreenView {
    
    // MARK: - Appearance
    
    var appearance: Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        setupStatusBarView()
    }
    
    // MARK: - Initializer
    
    init(frame: CGRect = .zero, appearance: Appearance, statusBarView: UIView = UIView()) {
        self.appearance = appearance
        super.init(frame: frame, statusBarView: statusBarView)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = appearance.primaryBackground
    }
    
}
