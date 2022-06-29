//
//  CurrenciesAmountMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 29.06.2022.
//

import Foundation
import MoneyTrackerPresentation

typealias PresentationCurrenciesAmount = MoneyTrackerPresentation.CurrenciesAmount

enum CurrenciesAmountMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentationCurrenciesAmount(_ currenciesAmount: CurrenciesAmount) -> PresentationCurrenciesAmount {
        let hhh = currenciesAmount.currenciesAmount.map({ CurrencyAmountMapper.mapToPresentationCurrencyAmount($0) })
        return PresentationCurrenciesAmount(currenciesMoneyAmount: hhh)
    }
    
}
