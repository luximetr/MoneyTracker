//
//  ScreenLocalizer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import Foundation
import AFoundation

final class ScreenLocalizer {
    
    // MARK: Initializer
    
    init(language: Language, stringsTableName: String? = nil, stringsdictTableName: String? = nil) {
        var textLocalizers: [TextLocalizer] = []
        if let stringsTableName = stringsTableName, let bundle = Bundle.forLanguage(language) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        if let stringsdictTableName = stringsdictTableName, let bundle = Bundle.forLanguage(language) {
            let textLocalizer = TableNameBundleTextLocalizer(tableName: stringsdictTableName, bundle: bundle)
            textLocalizers.append(textLocalizer)
        }
        textLocalizer = MultipleTextLocalizer(textLocalizers: textLocalizers)
    }
    
    // MARK:
    
    private var textLocalizer: TextLocalizer
    
    func localizeText(_ text: String, _ arguments: CVarArg...) -> String {
        let text = textLocalizer.localizeText(text, arguments: arguments) ?? ""
        return text
    }
    
}
