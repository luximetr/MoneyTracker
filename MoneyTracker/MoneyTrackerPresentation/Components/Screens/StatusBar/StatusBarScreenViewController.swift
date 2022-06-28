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
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        self.statusBarStyle = appearance.colors.statusBarStyle
        didSetStatusBarStyle()
    }
    
    // MARK: Language
    
    var locale: Locale
    
    // MARK: Calendar
    
    var calendar: Calendar
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, calendar: Calendar = Calendar.current) {
        self.appearance = appearance
        self.locale = locale
        self.calendar = calendar
        super.init()
        self.statusBarStyle = appearance.colors.statusBarStyle
    }
  
    // MARK: - Events
    
    func setLocale(_ locale: Locale) {
        self.locale = locale
    }
    
}
