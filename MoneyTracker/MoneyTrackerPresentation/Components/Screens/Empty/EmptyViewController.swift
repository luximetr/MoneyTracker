//
//  EmptyViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 17.04.2022.
//

import AUIKit

class EmptyViewController: AUIEmptyViewController {
    
    // MARK: - Initializer
    
    init(locale: MyLocale) {
        self.locale = locale
        super.init()
    }
    
    // MARK: - Language
    
    private (set) var locale: MyLocale
    
    func changeLocale(_ locale: MyLocale) {
        self.locale = locale
    }
}
