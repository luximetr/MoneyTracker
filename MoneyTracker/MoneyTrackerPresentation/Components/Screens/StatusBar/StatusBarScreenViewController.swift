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
        self.statusBarStyle = appearance.statusBarStyle
        didSetStatusBarStyle()
    }
    
    // MARK: Language
    
    var language: Language
    
    // MARK: - Initializer
    
    init(appearance: Appearance, language: Language) {
        self.appearance = appearance
        self.language = language
        super.init()
        self.statusBarStyle = appearance.statusBarStyle
    }
  
    // MARK: - Events
    
    func changeLanguage(_ language: Language) {
        self.language = language
    }
    
}
