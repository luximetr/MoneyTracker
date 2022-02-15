//
//  Account.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 14.02.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAccount = MoneyTrackerPresentation.Account
import MoneyTrackerStorage
import UIKit
typealias StorageAccount = MoneyTrackerStorage.Account

struct Account: Equatable, Hashable {
    
    let id: String
    let name: String
    let balance: Decimal
    let currency: Currency
    let backgroundColor: Data
    
    // MARK: Initializer
    
    init(id: String, name: String, balance: Decimal, currency: Currency, backgroundColor: Data) {
        self.id = id
        self.name = name
        self.balance = balance
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
    
    // MARK: PresentationCategory
    
    init(presentationAccount: PresentationAccount) throws {
        self.id = presentationAccount.id
        self.name = presentationAccount.name
        self.balance = presentationAccount.balance.amount
        self.currency = Currency(presentationCurrency: presentationAccount.balance.currency)
        self.backgroundColor = try NSKeyedArchiver.archivedData(withRootObject: presentationAccount.backgroundColor, requiringSecureCoding: false)
    }
    
    func presentationAccount() throws -> PresentationAccount {
        let currency = self.currency.presentationCurrency
        guard let backgroundColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self.backgroundColor) else {
            throw Error("")
        }
        let balance = Balance(amount: balance, currency: currency)
        let presentationAccount = PresentationAccount(id: id, name: name, balance: balance, backgroundColor: backgroundColor)
        return presentationAccount
    }
    
    // MARK: StorageCategory
    
    init(storageAccount: StorageAccount) {
        self.id = storageAccount.id
        self.name = storageAccount.name
        self.balance = storageAccount.balance
        self.currency = Currency(storageCurrency: storageAccount.currency)
        self.backgroundColor = storageAccount.backgroundColor
    }
    
    var storageAccount: StorageAccount {
        let currency = self.currency.storageCurrency
        let storageCategoty = StorageAccount(id: id, name: name, balance: balance, currency: currency, backgroundColor: backgroundColor)
        return storageCategoty
    }
}
