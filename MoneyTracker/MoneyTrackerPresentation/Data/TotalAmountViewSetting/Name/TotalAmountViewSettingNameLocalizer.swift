//
//  TotalAmountViewSettingNameLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import Foundation

final class TotalAmountViewSettingNameLocalizer {
    
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
        let localizer = Localizer(locale: locale, stringsTableName: "TotalAmountViewSettingNameStrings")
        return localizer
    }()
    
    func name(_ totalAmountViewSetting: TotalAmountViewSetting) -> String {
        switch totalAmountViewSetting {
        case .basicCurrency: return localizer.localizeText("basicCurrency")
        case .originalCurrencies: return localizer.localizeText("originalCurrencies")
        }
    }
    
}
