//
//  Bundle.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import Foundation

private class Class { }

extension Bundle {
    
    private static var previousLanguage: Language?
    private static var previousLanguageBundle: Bundle?
    
    class func forLanguage(_ language: Language) -> Bundle? {
        if language == previousLanguage {
            return previousLanguageBundle
        } else {
            let resource: String
            switch language {
            case .english:
                resource = "en"
            }
            let type = "lproj"
            let bundle = Bundle(path: Bundle(for: Class.self).path(forResource: resource, ofType: type) ?? "")
            previousLanguage = language
            previousLanguageBundle = bundle
            return bundle
        }
    }
    
}
