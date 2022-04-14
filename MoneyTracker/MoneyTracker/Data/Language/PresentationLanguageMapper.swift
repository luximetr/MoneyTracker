//
//  PresentationLanguageMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 14.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationLanguage = MoneyTrackerPresentation.Language

enum PresentationLanguageMapper {
    
    static func mapLanguageToPresentationLanguage(_ language: Language) -> PresentationLanguage {
        switch language {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
    static func mapPresentationLanguageToLanguage(_ presentationLanguage: PresentationLanguage) -> Language {
        switch presentationLanguage {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
}
