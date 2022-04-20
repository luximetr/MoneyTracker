//
//  PresentationAppearanceSettingMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAppearanceSetting = MoneyTrackerPresentation.AppearanceSetting

enum PresentationAppearanceSettingMapper {
    
    static func mapAppearanceSettingToPresentationAppearanceSetting(_ appearanceSetting: AppearanceSetting) -> PresentationAppearanceSetting {
        switch appearanceSetting {
        case .light: return .light
        case .dark: return .dark
        case .system: return .system
        }
    }
    
    static func mapPresentationAppearanceSettingToAppearanceSetting(_ presentationAppearanceSetting: PresentationAppearanceSetting) -> AppearanceSetting {
        switch presentationAppearanceSetting {
        case .light: return .light
        case .dark: return .dark
        case .system: return .system
        }
    }
    
}
