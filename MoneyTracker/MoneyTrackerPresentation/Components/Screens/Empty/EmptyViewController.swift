//
//  EmptyViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 17.04.2022.
//

import AUIKit

class EmptyViewController: AUIEmptyViewController {
    
    // MARK: - Initializer
    
    init(locale: Locale) {
        self.locale = locale
        super.init()
    }
    
    // MARK: - Language
    
    private (set) var locale: Locale
    
    func changeLocale(_ locale: Locale) {
        self.locale = locale
    }
}
