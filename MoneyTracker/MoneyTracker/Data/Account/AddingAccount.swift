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
typealias StorageAddingAccount = MoneyTrackerStorage.AddingAccount

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
    
    init(presentationAddingAccount: PresentationAddingAccount) {
        self.name = presentationAddingAccount.name
        self.amount = presentationAddingAccount.amount
        self.currency = Currency(presentationCurrency: presentationAddingAccount.currency)
        self.backgroundColor = try! NSKeyedArchiver.archivedData(withRootObject: presentationAddingAccount.backgroundColor, requiringSecureCoding: false)
    }
    
    var presentationAddingAccount: PresentationAddingAccount {
        let currency = currency.presentationCurrency
        let backgroundColor = (try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self.backgroundColor))!
        let presentationAddingAccount = PresentationAddingAccount(name: name, amount: amount, currency: currency, backgroundColor: backgroundColor)
        return presentationAddingAccount
    }
    
    // MARK: StorageCategory
    
    init(storageAddingAccount: StorageAddingAccount) {
        self.name = storageAddingAccount.name
        self.amount = storageAddingAccount.balance
        self.currency = Currency(storageCurrency: storageAddingAccount.currency)
        self.backgroundColor = storageAddingAccount.backgroundColor
    }
    
    var storageAddingAccount: StorageAddingAccount {
        let currency = currency.storageCurrency
        let storageAddingCategoty = StorageAddingAccount(name: name, balance: amount, currency: currency, backgroundColor: backgroundColor)
        return storageAddingCategoty
    }
}
