//
//  EditingBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 24.04.2022.
//

import Foundation
import MoneyTrackerStorage
import MoneyTrackerPresentation

typealias StorageEditingBalanceAccount = MoneyTrackerStorage.EditingBalanceAccount
typealias PresentationEditingBalanceAccount = MoneyTrackerPresentation.EditingAccount

class EditingBalanceAccountAdapter {
    
    private let currencyAdapter = CurrencyAdapter()
    private let accountColorAdapter = BalanceAccountColorAdapter()
    
    func adaptToStorage(presentationEditingAccount: PresentationEditingBalanceAccount) -> StorageEditingBalanceAccount {
        return StorageEditingBalanceAccount(
            id: presentationEditingAccount.id,
            name: presentationEditingAccount.name,
            currency: currencyAdapter.adaptToStorage(presentationCurrency: presentationEditingAccount.currency),
            amount: presentationEditingAccount.amount,
            color: accountColorAdapter.adaptToStorage(presentationAccountColor: presentationEditingAccount.color)
        )
    }
}
