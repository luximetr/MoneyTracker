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
            case .SGD: return .SGD
            case .USD: return .USD
            case .UAH: return .UAH
            case .TRY: return .TRY
            case .THB: return .THB
            case .EUR: return .EUR
        }
    }
    
    func adaptToPresentationCurrency(storageCurrency: StorageCurrency) -> PresentationCurrency {
        switch storageCurrency {
            case .SGD: return .SGD
            case .USD: return .USD
            case .UAH: return .UAH
            case .TRY: return .TRY
            case .THB: return .THB
            case .EUR: return .EUR
        }
    }
}

enum Currency {
    case SGD
    case USD
    case UAH
    case TRY
    case THB
    case EUR
    
    init(presentationCurrency: PresentationCurrency) {
        switch presentationCurrency {
            case .SGD: self = .SGD
            case .USD: self = .USD
            case .UAH: self = .UAH
            case .TRY: self = .TRY
            case .THB: self = .THB
            case .EUR: self = .EUR
        }
    }
    
    var presentationCurrency: PresentationCurrency {
        switch self {
            case .SGD: return .SGD
            case .USD: return .USD
            case .UAH: return .UAH
            case .TRY: return .TRY
            case .THB: return .THB
            case .EUR: return .EUR
        }
    }
    
    init(storageCurrency: StorageCurrency) {
        switch storageCurrency {
            case .SGD: self = .SGD
            case .USD: self = .USD
            case .UAH: self = .UAH
            case .TRY: self = .TRY
            case .THB: self = .THB
            case .EUR: self = .EUR
        }
    }
    
    var storageCurrency: StorageCurrency {
        switch self {
            case .SGD: return .SGD
            case .USD: return .USD
            case .UAH: return .UAH
            case .TRY: return .TRY
            case .THB: return .THB
            case .EUR: return .EUR
        }
    }
    
}
