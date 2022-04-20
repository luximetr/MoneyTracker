//
//  StorageAppearanceSettingMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import Foundation
import MoneyTrackerStorage
typealias StorageAppearanceSetting = MoneyTrackerStorage.AppearanceSetting

enum StorageAppearanceSettingMapper {
    
    static func mapAppearanceSettingToStorageAppearanceSetting(_ appearanceSetting: AppearanceSetting) -> StorageAppearanceSetting {
        switch appearanceSetting {
        case .light: return .light
        case .dark: return .dark
        case .system: return .system
        }
    }
    
    static func mapStorageAppearanceSettingToAppearanceSetting(_ storageAppearanceSetting: StorageAppearanceSetting) -> AppearanceSetting {
        switch storageAppearanceSetting {
        case .light: return .light
        case .dark: return .dark
        case .system: return .system
        }
    }
    
}
