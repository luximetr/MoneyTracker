//
//  LanguageNameLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import Foundation

final class LanguageNameLocalizer {
    
    // MARK: - Data
    
    private var language: Language
    
    func changeLanguage(_ language: Language) {
        self.language = language
        localizer.changeLanguage(language)
    }
    
    // MARK: - Initializer
    
    init(language: Language) {
        self.language = language
    }
    
    // MARK: - Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: language, stringsTableName: "LanguageNameStrings")
        return localizer
    }()
    
    func name(_ language: Language) -> String {
        switch language {
        case .english: return localizer.localizeText("english")
        case .ukrainian: return localizer.localizeText("ukrainian")
        case .thai: return localizer.localizeText("thai")
        }
    }
    
}
