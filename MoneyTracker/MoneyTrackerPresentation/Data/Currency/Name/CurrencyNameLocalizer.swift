//
//  CurrencyNameProvider.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 10.02.2022.
//

import Foundation

class CurrencyNameLocalizer {
    
    // MARK: - Data
    
    private var locale: Locale
    
    func changeLocale(_ locale: Locale) {
        self.locale = locale
        localizer.changeLocale(locale)
    }
    
    // MARK: - Initializer
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    // MARK: - Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "CurrencyNameStrings")
        return localizer
    }()
    
    func name(_ currency: Currency) -> String {
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
