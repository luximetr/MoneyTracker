//
//  LanguageNameLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import Foundation

final class LanguageNameLocalizer {
    
    // MARK: - Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "LanguageNameStrings")
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
