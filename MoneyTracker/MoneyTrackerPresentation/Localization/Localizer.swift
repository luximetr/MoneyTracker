//
//  ScreenLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import Foundation
import AFoundation

final class Localizer {
        
    private var locale: Locale
    private let stringsTableName: String?
    private let stringsdictTableName: String?
    
    // MARK: - Initialization
    
    init(locale: Locale, stringsTableName: String? = nil, stringsdictTableName: String? = nil) {
        self.locale = locale
        self.stringsTableName = stringsTableName
        self.stringsdictTableName = stringsdictTableName
        var textLocalizers: [AFoundation.TextLocalizer] = []
        if let stringsTableName = stringsTableName, let bundle = Bundle.forLocale(locale) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        if let stringsdictTableName = stringsdictTableName, let bundle = Bundle.forLocale(locale) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsdictTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        self.textLocalizer = MultipleTextLocalizer(textLocalizers: textLocalizers)
    }
    
    // MARK: - Localizer
    
    private var textLocalizer: AFoundation.TextLocalizer
    
    func localizeText(_ text: String, _ arguments: CVarArg...) -> String {
        let text = textLocalizer.localizeText(text, arguments: arguments) ?? ""
        return text
    }
    
    // MARK: - Locale
    
    func setLocale(_ locale: Locale) {
        self.locale = locale
        var textLocalizers: [AFoundation.TextLocalizer] = []
        if let stringsTableName = stringsTableName, let bundle = Bundle.forLocale(locale) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        if let stringsdictTableName = stringsdictTableName, let bundle = Bundle.forLocale(locale) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsdictTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        self.textLocalizer = MultipleTextLocalizer(textLocalizers: textLocalizers)
    }
    
}
