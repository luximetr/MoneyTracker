//
//  CurrencyCodeLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import Foundation

final class CurrencyCodeLocalizer {
    
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
        let localizer = Localizer(language: .english, stringsTableName: "CurrencyCodeStrings")
        return localizer
    }()
    
    func code(_ currency: Currency) -> String {
        switch currency {
            case .singaporeDollar: return localizer.localizeText("singaporeDollar")
            case .usDollar: return localizer.localizeText("usDollar")
            case .hryvnia: return localizer.localizeText("hryvnia")
            case .turkishLira: return localizer.localizeText("turkishLira")
            case .baht: return localizer.localizeText("baht")
            case .euro: return localizer.localizeText("euro")
        }
    }
    
}
