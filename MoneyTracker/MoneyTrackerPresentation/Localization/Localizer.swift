//
//  ScreenLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import Foundation
import AFoundation

final class Localizer {
    
    // MARK: - Language
    
    private var locale: Locale
    private let stringsTableName: String?
    private let stringsdictTableName: String?
    
    func changeLocale(_ locale: Locale) {
        self.locale = locale
        let language = locale.language
        var textLocalizers: [AFoundation.TextLocalizer] = []
        if let stringsTableName = stringsTableName, let bundle = Bundle.localizedFor(language: language) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        if let stringsdictTableName = stringsdictTableName, let bundle = Bundle.localizedFor(language: language) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsdictTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        self.textLocalizer = MultipleTextLocalizer(textLocalizers: textLocalizers)
    }
    
    // MARK: - Initializer
    
    init(locale: Locale, stringsTableName: String? = nil, stringsdictTableName: String? = nil) {
        self.locale = locale
        self.stringsTableName = stringsTableName
        self.stringsdictTableName = stringsdictTableName
        var textLocalizers: [AFoundation.TextLocalizer] = []
        let language = locale.language
        if let stringsTableName = stringsTableName, let bundle = Bundle.localizedFor(language: language) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        if let stringsdictTableName = stringsdictTableName, let bundle = Bundle.localizedFor(language: language) {
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
    
}
