//
//  Locale.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.05.2022.
//

import Foundation

class MyLocale {
    
    let language: Language
    let scriptCode: String?
    let regionCode: String?
    let locale: Locale
    
    init(language: Language, scriptCode: String?, regionCode: String?) {
        self.language = language
        self.scriptCode = scriptCode
        self.regionCode = regionCode
        let languageCode: String
        switch language {
        case .english: languageCode = "en"
        case .ukrainian: languageCode = "uk"
        case .thai: languageCode = "th"
        }
        var identifier = languageCode
        if let scriptCode = scriptCode { identifier += "-\(scriptCode)" }
        if let regionCode = regionCode { identifier += "_\(regionCode)" }
        self.locale = Locale(identifier: identifier)
    }
    
}
