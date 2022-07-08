//
//  CurrencyCodeLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import Foundation

final class CurrencyCodeLocalizer {
    
    // MARK: - Data
    
    private var locale: Locale
    
    func setLocale(_ locale: Locale) {
        self.locale = locale
        localizer.setLocale(locale)
    }
    
    // MARK: - Initializer
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    // MARK: - Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "CurrencyCodeStrings")
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
