//
//  TotalAmountViewSettingMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 04.07.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias StorageTotalAmountViewSetting = MoneyTrackerStorage.TotalAmountViewSetting
typealias PresentationTotalAmountViewSetting = MoneyTrackerPresentation.TotalAmountViewSetting

enum TotalAmountViewSettingMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentationTotalAmountViewSetting(_ totalAmountViewSetting: TotalAmountViewSetting) -> PresentationTotalAmountViewSetting {
        switch totalAmountViewSetting {
        case .basicCurrency: return .basicCurrency
        case .originalCurrencies: return .originalCurrencies
        }
    }
    
    static func mapToTotalAmountViewSetting(_ presentationTotalAmountViewSetting: PresentationTotalAmountViewSetting) -> TotalAmountViewSetting {
        switch presentationTotalAmountViewSetting {
        case .basicCurrency: return .basicCurrency
        case .originalCurrencies: return .originalCurrencies
        }
    }
    
    // MARK: - Storage
    
    static func mapToStorageTotalAmountViewSetting(_ totalAmountViewSetting: TotalAmountViewSetting) -> StorageTotalAmountViewSetting {
        switch totalAmountViewSetting {
        case .basicCurrency: return .basicCurrency
        case .originalCurrencies: return .originalCurrencies
        }
    }
    
    static func mapToTotalAmountViewSetting(_ storageTotalAmountViewSetting: StorageTotalAmountViewSetting) -> TotalAmountViewSetting {
        switch storageTotalAmountViewSetting {
        case .basicCurrency: return .basicCurrency
        case .originalCurrencies: return .originalCurrencies
        }
    }
    
}
