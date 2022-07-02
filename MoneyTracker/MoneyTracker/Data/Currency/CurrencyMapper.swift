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
    
    static func mapToPresentationCurrency(_ storageCurrency: StorageCurrency) -> PresentationCurrency {
        switch storageCurrency {
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
    
    static func mapToStorageCurrency(_ presentationCurrency: PresentationCurrency) -> StorageCurrency {
        switch presentationCurrency {
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
    
    // MARK: - Fawazahmed0CurrencyApi
    
    static func mapToFawazahmed0CurrencyApiVersionaCurrency(_ currency: Currency) -> Fawazahmed0CurrencyApiVersionaCurrency {
        switch currency {
        case .singaporeDollar: return .singaporeDollar
        case .usDollar: return .usDollar
        case .hryvnia: return .hryvnia
        case .turkishLira: return .turkishLira
        case .baht: return .baht
        case .euro: return .euro
        }
    }
    
    static func mapToFawazahmed0CurrencyApiVersionaCurrency(_ presentationCurrency: PresentationCurrency) -> Fawazahmed0CurrencyApiVersionaCurrency {
        switch presentationCurrency {
        case .singaporeDollar: return .singaporeDollar
        case .usDollar: return .usDollar
        case .hryvnia: return .hryvnia
        case .turkishLira: return .turkishLira
        case .baht: return .baht
        case .euro: return .euro
        }
    }
    
}
