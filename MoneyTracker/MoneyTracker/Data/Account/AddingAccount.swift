//
//  AddingAccount.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 15.02.2022.
//

import Foundation
import UIKit
import MoneyTrackerPresentation
typealias PresentationAddingAccount = MoneyTrackerPresentation.AddingAccount
import MoneyTrackerStorage
typealias StorageAddingAccount = MoneyTrackerStorage.AddingBalanceAccount

struct AddingAccount: Equatable, Hashable {
    
    let name: String
    let amount: Decimal
    let currency: Currency
    let backgroundColor: Data
    
    init(name: String, amount: Decimal, currency: Currency, backgroundColor: Data) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
    
    // MARK: PresentationCategory
    
    init(presentationAddingAccount: PresentationAddingAccount) throws {
        do {
            self.name = presentationAddingAccount.name
            self.amount = presentationAddingAccount.amount
            self.currency = Currency(presentationCurrency: presentationAddingAccount.currency)
            self.backgroundColor = try NSKeyedArchiver.archivedData(withRootObject: presentationAddingAccount.backgroundColor, requiringSecureCoding: true)
        } catch {
            let error = Error("Cannot initialize\n\(error)")
            throw error
        }
    }
    
    // MARK: StorageCategory
    
    init(storageAddingAccount: StorageAddingAccount) {
        self.name = storageAddingAccount.name
        self.amount = storageAddingAccount.amount
        self.currency = Currency(storageCurrency: storageAddingAccount.currency)
        self.backgroundColor = storageAddingAccount.backgroundColor
    }
    
    var storageAddingAccount: StorageAddingAccount {
        let currency = currency.storageCurrency
        let storageAddingCategoty = StorageAddingAccount(name: name, amount: amount, currency: currency, backgroundColor: backgroundColor)
        return storageAddingCategoty
    }
}
