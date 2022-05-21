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
    
    private var language: Language
    private let stringsTableName: String?
    private let stringsdictTableName: String?
    
    func changeLanguage(_ language: Language) {
        self.language = language
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
    
    init(language: Language, stringsTableName: String? = nil, stringsdictTableName: String? = nil) {
        self.language = language
        self.stringsTableName = stringsTableName
        self.stringsdictTableName = stringsdictTableName
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
    
    // MARK: - Localizer
    
    private var textLocalizer: AFoundation.TextLocalizer
    
    func localizeText(_ text: String, _ arguments: CVarArg...) -> String {
        let text = textLocalizer.localizeText(text, arguments: arguments) ?? ""
        return text
    }
    
}
