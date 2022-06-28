//
//  PresentationLanguageMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 14.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationLanguage = MoneyTrackerPresentation.Language
typealias StorageLanguage = MoneyTrackerStorage.Language

enum LanguageMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentationLanguage(_ language: Language) -> PresentationLanguage {
        switch language {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
    static func mapToLanguage(_ presentationLanguage: PresentationLanguage) -> Language {
        switch presentationLanguage {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
    // MARK: - Storage
    
    static func mapToStorageLanguage(_ language: Language) -> StorageLanguage {
        switch language {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
    static func mapToLanguage(_ storageLanguage: StorageLanguage) -> Language {
        switch storageLanguage {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
}
