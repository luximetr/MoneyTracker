//
//  Locale.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.05.2022.
//

import Foundation

extension Locale {
    
    // MARK: Initializer
    
    init(language: Language, scriptCode: String?, regionCode: String?) {
        let languageCode: String
        switch language {
        case .english: languageCode = "en"
        case .ukrainian: languageCode = "uk"
        case .thai: languageCode = "th"
        }
        var identifier = languageCode
        if let scriptCode = scriptCode { identifier += "-\(scriptCode)" }
        if let regionCode = regionCode { identifier += "_\(regionCode)" }
        self.init(identifier: identifier)
    }
    
    // MARK: Language
  
    func language() throws -> Language? {
        guard let languageCode = languageCode else { return nil }
        let language: Language
        switch languageCode {
        case "en": language = .english
        case "uk": language = .ukrainian
        case "th": language = .thai
        default:
            throw Error("Cannot get \(String(reflecting: Language.self)) for \(String(reflecting: Locale.self))(\(String(reflecting: self)))")
        }
        return language
    }
    
}
