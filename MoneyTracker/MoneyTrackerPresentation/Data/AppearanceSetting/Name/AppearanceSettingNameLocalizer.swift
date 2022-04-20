//
//  AppearanceTypeNameLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import Foundation

final class AppearanceSettingNameLocalizer {
    
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
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "AppearanceSettingNameStrings")
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
