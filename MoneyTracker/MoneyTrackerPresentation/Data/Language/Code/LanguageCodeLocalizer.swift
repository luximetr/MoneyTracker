//
//  LanguageCodeLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import Foundation

final class LanguageCodeLocalizer {
    
    // MARK: - Data
    
    private var locale: Locale
    
    func changeLocale(_ locale: Locale) {
        self.locale = locale
        localizer.setLocale(locale)
    }
    
    // MARK: - Initializer
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    // MARK: - Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "LanguageCodeStrings")
        return localizer
    }()
    
    func code(_ language: Language) -> String {
        switch language {
        case .english: return localizer.localizeText("english")
        case .ukrainian: return localizer.localizeText("ukrainian")
        case .thai: return localizer.localizeText("thai")
        }
    }
    
}
