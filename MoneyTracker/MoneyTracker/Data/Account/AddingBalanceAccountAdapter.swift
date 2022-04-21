//
//  AddingBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 21.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationAddingBalanceAccount = MoneyTrackerPresentation.AddingAccount
typealias StorageAddingBalanceAccount = MoneyTrackerStorage.AddingBalanceAccount

class AddingBalanceAccountAdapter {
    
    private let currencyAdapter = CurrencyAdapter()
    private let accountColorAdapter = BalanceAccountColorAdapter()
    
    func adaptToStorage(presentationAddingAccount: PresentationAddingBalanceAccount) -> StorageAddingBalanceAccount {
        return StorageAddingBalanceAccount(
            name: presentationAddingAccount.name,
            amount: presentationAddingAccount.amount,
            currency: currencyAdapter.adaptToStorage(presentationCurrency: presentationAddingAccount.currency),
            color: accountColorAdapter.adaptToStorage(presentationAccountColor: presentationAddingAccount.color)
        )
    }
    
    func adaptToPresentation(storageAddingAccount: StorageAddingBalanceAccount) -> PresentationAddingBalanceAccount {
        return PresentationAddingBalanceAccount(
            name: storageAddingAccount.name,
            amount: storageAddingAccount.amount,
            currency: currencyAdapter.adaptToPresentation(storageCurrency: storageAddingAccount.currency),
            color: accountColorAdapter.adaptToPresentation(storageAccountColor: storageAddingAccount.color)
        )
    }
}
