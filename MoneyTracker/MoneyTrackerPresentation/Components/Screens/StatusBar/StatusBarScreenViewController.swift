//
//  StatusBarScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit
import AUIKit

class StatusBarScreenViewController: AUIStatusBarScreenViewController {
  
    // MARK: - Appearance
    
    var appearance: Appearance
    
    // MARK: - Initializer
    
    init(appearance: Appearance = LightAppearance()) {
        self.appearance = appearance
        super.init()
        self.statusBarStyle = appearance.statusBarStyle
    }
  
    // MARK: - Events
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        self.statusBarStyle = appearance.statusBarStyle
        didSetStatusBarStyle()
    }
    
}
