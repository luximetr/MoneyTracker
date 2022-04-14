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
            case .english: resource = "en"
            case .ukrainian: resource = "en"
            case .thai: resource = "en"
            }
            let type = "lproj"
            if let path = Bundle(for: Class.self).path(forResource: resource, ofType: type) {
                let bundle = Bundle(path: path)
                previousLanguage = language
                previousLanguageBundle = bundle
                return bundle
            } else {
                return nil
            }
        }
    }
    
}
