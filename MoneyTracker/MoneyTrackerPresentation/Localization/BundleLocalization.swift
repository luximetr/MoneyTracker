//
//  Bundle.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import Foundation

private class Class { }

extension Bundle {
    
    class func forLocale(_ locale: Locale) -> Bundle? {
        let language = locale.language
        let languageCode: String
        switch language {
        case .english: languageCode = "en"
        case .ukrainian: languageCode = "uk"
        case .thai: languageCode = "th"
        }
        let bundle = localizedFor(language: languageCode, region: nil)
        return bundle
    }
    
    private static var localizedBundles: [String: Bundle] = [:]
    
    class func localizedFor(language: String, region: String?) -> Bundle? {
        var resource = language
        if let region = region {
            resource += "_\(region)"
        }
        if let bundle = localizedBundles[resource] {
            return bundle
        } else {
            let resource = language
            let type = "lproj"
            if let path = Bundle(for: Class.self).path(forResource: resource, ofType: type) {
                let bundle = Bundle(path: path)
                localizedBundles[resource] = bundle
                return bundle
            } else {
                return nil
            }
        }
    }
    
}
