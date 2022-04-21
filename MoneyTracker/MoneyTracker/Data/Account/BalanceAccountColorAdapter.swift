//
//  BalanceAccountColorAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 21.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationBalanceAccountColor = MoneyTrackerPresentation.AccountColor
typealias StorageBalanceAccountColor = MoneyTrackerStorage.BalanceAccountColor

class BalanceAccountColorAdapter {
    
    func adaptToStorage(presentationAccountColor: PresentationBalanceAccountColor) -> StorageBalanceAccountColor {
        switch presentationAccountColor {
            case .variant1: return .variant1
            case .variant2: return .variant2
            case .variant3: return .variant3
            case .variant4: return .variant4
            case .variant5: return .variant5
            case .variant6: return .variant6
            case .variant7: return .variant7
            case .variant8: return .variant8
            case .variant9: return .variant9
            case .variant10: return .variant10
            case .variant11: return .variant11
            case .variant12: return .variant12
            case .variant13: return .variant13
            case .variant14: return .variant14
            case .variant15: return .variant15
            case .variant16: return .variant16
            case .variant17: return .variant17
            case .variant18: return .variant18
            case .variant19: return .variant19
            case .variant20: return .variant20
        }
    }
    
    func adaptToPresentation(storageAccountColor: StorageBalanceAccountColor) -> PresentationBalanceAccountColor {
        switch storageAccountColor {
            case .variant1: return .variant1
            case .variant2: return .variant2
            case .variant3: return .variant3
            case .variant4: return .variant4
            case .variant5: return .variant5
            case .variant6: return .variant6
            case .variant7: return .variant7
            case .variant8: return .variant8
            case .variant9: return .variant9
            case .variant10: return .variant10
            case .variant11: return .variant11
            case .variant12: return .variant12
            case .variant13: return .variant13
            case .variant14: return .variant14
            case .variant15: return .variant15
            case .variant16: return .variant16
            case .variant17: return .variant17
            case .variant18: return .variant18
            case .variant19: return .variant19
            case .variant20: return .variant20
        }
    }
}
