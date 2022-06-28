//
//  Currency.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 25.06.2022.
//

enum Currency {
    case singaporeDollar
    case usDollar
    case hryvnia
    case turkishLira
    case baht
    case euro
    
    init(presentationCurrency: PresentationCurrency) {
        switch presentationCurrency {
            case .singaporeDollar: self = .singaporeDollar
            case .usDollar: self = .usDollar
            case .hryvnia: self = .hryvnia
            case .turkishLira: self = .turkishLira
            case .baht: self = .baht
            case .euro: self = .euro
        }
    }
    
    var presentationCurrency: PresentationCurrency {
        switch self {
            case .singaporeDollar: return .singaporeDollar
            case .usDollar: return .usDollar
            case .hryvnia: return .hryvnia
            case .turkishLira: return .turkishLira
            case .baht: return .baht
            case .euro: return .euro
        }
    }
    
    init(storageCurrency: StorageCurrency) {
        switch storageCurrency {
            case .singaporeDollar: self = .singaporeDollar
            case .usDollar: self = .usDollar
            case .hryvnia: self = .hryvnia
            case .turkishLira: self = .turkishLira
            case .baht: self = .baht
            case .euro: self = .euro
        }
    }
    
    var storageCurrency: StorageCurrency {
        switch self {
            case .singaporeDollar: return .singaporeDollar
            case .usDollar: return .usDollar
            case .hryvnia: return .hryvnia
            case .turkishLira: return .turkishLira
            case .baht: return .baht
            case .euro: return .euro
        }
    }
    
}
