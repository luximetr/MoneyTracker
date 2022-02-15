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

enum Currency {
    case sgd
    case usd
    case uah
    
    init(presentationCurrency: PresentationCurrency) {
        switch presentationCurrency {
            case .sgd: self = .sgd
            case .usd: self = .usd
            case .uah: self = .uah
        }
    }
    
    var presentationCurrency: PresentationCurrency {
        switch self {
            case .sgd: return .sgd
            case .usd: return .usd
            case .uah: return .uah
        }
    }
    
    init(storageCurrency: StorageCurrency) {
        switch storageCurrency {
            case .sgd: self = .sgd
            case .usd: self = .usd
            case .uah: self = .uah
        }
    }
    
    var storageCurrency: StorageCurrency {
        switch self {
            case .sgd: return .sgd
            case .usd: return .usd
            case .uah: return .uah
        }
    }
    
}
