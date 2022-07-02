//
//  BalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 21.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage
import UIKit

typealias PresentationBalanceAccount = MoneyTrackerPresentation.Account
typealias StorageBalanceAccount = MoneyTrackerStorage.BalanceAccount

class BalanceAccountAdapter {
    
    private let accountColorAdapter = BalanceAccountColorAdapter()
    
    func adaptToStorage(presentationAccount: PresentationBalanceAccount) -> StorageBalanceAccount {
        return StorageBalanceAccount(
            id: presentationAccount.id,
            name: presentationAccount.name,
            amount: presentationAccount.amount,
            currency: CurrencyMapper.mapToStorageCurrency(presentationAccount.currency),
            color: accountColorAdapter.adaptToStorage(presentationAccountColor: presentationAccount.color)
        )
    }
    
    func adaptToPresentation(storageAccount: StorageBalanceAccount) -> PresentationBalanceAccount {
        return PresentationBalanceAccount(
            id: storageAccount.id,
            name: storageAccount.name,
            amount: storageAccount.amount,
            currency: CurrencyMapper.mapToPresentationCurrency(storageAccount.currency),
            color: accountColorAdapter.adaptToPresentation(storageAccountColor: storageAccount.color ?? .variant1)
        )
    }
}
