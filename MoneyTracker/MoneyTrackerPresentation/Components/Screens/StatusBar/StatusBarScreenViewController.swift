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
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        self.statusBarStyle = appearance.colors.statusBarStyle
        didSetStatusBarStyle()
    }
    
    // MARK: Language
    
    var locale: MyLocale
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: MyLocale) {
        self.appearance = appearance
        self.locale = locale
        super.init()
        self.statusBarStyle = appearance.colors.statusBarStyle
    }
  
    // MARK: - Events
    
    func changeLocale(_ locale: MyLocale) {
        self.locale = locale
    }
    
}
