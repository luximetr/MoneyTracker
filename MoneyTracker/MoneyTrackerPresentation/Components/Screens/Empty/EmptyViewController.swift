//
//  EmptyViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 17.04.2022.
//

import AUIKit

class EmptyViewController: AUIEmptyViewController {
    
    // MARK: - Initializer
    
    init(language: Language) {
        self.language = language
        super.init()
    }
    
    // MARK: - Language
    
    private (set) var language: Language
    
    func changeLanguage(_ language: Language) {
        self.language = language
    }
}
