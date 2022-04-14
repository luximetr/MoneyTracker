//
//  StorageLanguageMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 14.04.2022.
//

import Foundation
import MoneyTrackerStorage
typealias StorageLanguage = MoneyTrackerStorage.Language

enum StorageLanguageMapper {
    
    static func mapLanguageToStorageLanguage(_ language: Language) -> StorageLanguage {
        switch language {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
    static func mapStorageLanguageToLanguage(_ storageLanguage: StorageLanguage) -> Language {
        switch storageLanguage {
        case .english: return .english
        case .ukrainian: return .ukrainian
        case .thai: return .thai
        }
    }
    
}
