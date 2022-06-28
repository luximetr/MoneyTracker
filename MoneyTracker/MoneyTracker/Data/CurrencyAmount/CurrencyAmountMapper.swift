//
//  CurrencyAmountMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 29.06.2022.
//

import Foundation
import MoneyTrackerPresentation

typealias PresentationCurrencyAmount = MoneyTrackerPresentation.CurrencyAmount

enum CurrencyAmountMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentationCurrencyAmount(_ currencyAmount: CurrencyAmount) -> PresentationCurrencyAmount {
        let currency = currencyAmount.currency
        let presentationCurrency = CurrencyMapper.mapToPresentationCurrency(currency)
        let amount = currencyAmount.amount
        let presentationCurrencyAmount = PresentationCurrencyAmount(amount: amount, currency: presentationCurrency)
        return presentationCurrencyAmount
    }
    
//    static func mapToCurrencyAmount(_ presentationCurrencyAmount: PresentationCurrencyAmount) -> CurrencyAmount {
//
//    }
    
}
