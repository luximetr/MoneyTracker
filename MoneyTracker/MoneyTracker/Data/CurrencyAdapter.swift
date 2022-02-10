//
//  CurrencyAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 10.02.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationCurrency = MoneyTrackerPresentation.Currency
typealias StorageCurrency = MoneyTrackerStorage.Currency

class CurrencyAdapter {
    
    func adaptToStorageCurrency(presentationCurrency: PresentationCurrency) -> StorageCurrency {
        switch presentationCurrency {
            case .sgd: return .sgd
            case .usd: return .usd
            case .uah: return .uah
        }
    }
    
    func adaptToPresentationCurrency(storageCurrency: StorageCurrency) -> PresentationCurrency {
        switch storageCurrency {
            case .sgd: return .sgd
            case .usd: return .usd
            case .uah: return .uah
        }
    }
}
