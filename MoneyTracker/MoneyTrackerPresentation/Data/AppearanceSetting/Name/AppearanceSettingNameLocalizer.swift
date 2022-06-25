//
//  AppearanceTypeNameLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import Foundation

final class AppearanceSettingNameLocalizer {
    
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
        let localizer = Localizer(locale: locale, stringsTableName: "AppearanceSettingNameStrings")
        return localizer
    }()
    
    func name(_ appearanceType: AppearanceSetting) -> String {
        switch appearanceType {
        case .light: return localizer.localizeText("light")
        case .dark: return localizer.localizeText("dark")
        case .system: return localizer.localizeText("system")
        }
    }
    
}
