//
//  Locale.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.05.2022.
//

import Foundation

public struct Locale {
    
    let language: Language
    let scriptCode: String?
    let regionCode: String?
    let foundationLocale: Foundation.Locale
    
    public init(language: Language, scriptCode: String?, regionCode: String?) {
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
        self.foundationLocale = Foundation.Locale(identifier: identifier)
    }
    
}
