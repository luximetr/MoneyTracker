//
//  CurrencyAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 10.02.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage
import Fawazahmed0CurrencyApi

typealias PresentationCurrency = MoneyTrackerPresentation.Currency
typealias StorageCurrency = MoneyTrackerStorage.Currency
typealias Fawazahmed0CurrencyApiVersionaCurrency = Fawazahmed0CurrencyApi.ApiVersion1Currency

class CurrencyAdapter {
    
    func adaptToStorage(presentationCurrency: PresentationCurrency) -> StorageCurrency {
        switch presentationCurrency {
            case .singaporeDollar: return .singaporeDollar
            case .usDollar: return .usDollar
            case .hryvnia: return .hryvnia
            case .turkishLira: return .turkishLira
            case .baht: return .baht
            case .euro: return .euro
        }
    }
    
    func adaptToStorageOptional(presentationCurrency: PresentationCurrency?) -> StorageCurrency? {
        guard let presentationCurrency = presentationCurrency else { return nil }
        return adaptToStorage(presentationCurrency: presentationCurrency)
    }
    
    func adaptToPresentation(storageCurrency: StorageCurrency) -> PresentationCurrency {
        switch storageCurrency {
            case .singaporeDollar: return .singaporeDollar
            case .usDollar: return .usDollar
            case .hryvnia: return .hryvnia
            case .turkishLira: return .turkishLira
            case .baht: return .baht
            case .euro: return .euro
        }
    }
    
    func mapFawazahmed0CurrencyApiVersionaCurrencyToPresentationCurrency(_ fawazahmed0CurrencyApiVersionaCurrency: PresentationCurrency) -> Fawazahmed0CurrencyApiVersionaCurrency {
        switch fawazahmed0CurrencyApiVersionaCurrency {
            case .singaporeDollar: return .singaporeDollar
            case .usDollar: return .usDollar
            case .hryvnia: return .hryvnia
            case .turkishLira: return .turkishLira
            case .baht: return .baht
            case .euro: return .euro
        }
    }
}

enum CurrencyMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentationCurrency(_ currency: Currency) -> PresentationCurrency {
        switch currency {
        case .singaporeDollar: return .singaporeDollar
        case .usDollar: return .usDollar
        case .hryvnia: return .hryvnia
        case .turkishLira: return .turkishLira
        case .baht: return .baht
        case .euro: return .euro
        }
    }
    
    static func mapToCurrency(_ presentationCurrency: PresentationCurrency) -> Currency {
        switch presentationCurrency {
        case .singaporeDollar: return .singaporeDollar
        case .usDollar: return .usDollar
        case .hryvnia: return .hryvnia
        case .turkishLira: return .turkishLira
        case .baht: return .baht
        case .euro: return .euro
        }
    }
    
    // MARK: - Storage
    
    static func mapToStorageCurrency(_ currency: Currency) -> StorageCurrency {
        switch currency {
        case .singaporeDollar: return .singaporeDollar
        case .usDollar: return .usDollar
        case .hryvnia: return .hryvnia
        case .turkishLira: return .turkishLira
        case .baht: return .baht
        case .euro: return .euro
        }
    }
    
    static func mapToCurrency(_ storageCurrency: StorageCurrency) -> Currency {
        switch storageCurrency {
        case .singaporeDollar: return .singaporeDollar
        case .usDollar: return .usDollar
        case .hryvnia: return .hryvnia
        case .turkishLira: return .turkishLira
        case .baht: return .baht
        case .euro: return .euro
        }
    }
    
}
