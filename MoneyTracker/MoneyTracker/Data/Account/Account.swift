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
    let amount: Decimal
    let currency: Currency
    let backgroundColor: Data
    
    // MARK: Initializer
    
    init(id: String, name: String, amount: Decimal, currency: Currency, backgroundColor: Data) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
    
    // MARK: PresentationCategory
    
    init(presentationAccount: PresentationAccount) throws {
        self.id = presentationAccount.id
        self.name = presentationAccount.name
        self.amount = presentationAccount.amount
        self.currency = Currency(presentationCurrency: presentationAccount.currency)
        self.backgroundColor = try NSKeyedArchiver.archivedData(withRootObject: presentationAccount.backgroundColor, requiringSecureCoding: false)
    }
    
    func presentationAccount() throws -> PresentationAccount {
        let currency = self.currency.presentationCurrency
        guard let backgroundColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self.backgroundColor) else {
            throw Error("")
        }
        let presentationAccount = PresentationAccount(id: id, name: name, amount: amount, currency: currency, backgroundColor: backgroundColor)
        return presentationAccount
    }
    
    // MARK: StorageCategory
    
    init(storageAccount: StorageAccount) {
        self.id = storageAccount.id
        self.name = storageAccount.name
        self.amount = storageAccount.amount
        self.currency = Currency(storageCurrency: storageAccount.currency)
        self.backgroundColor = storageAccount.backgroundColor
    }
    
    var storageAccount: StorageAccount {
        let currency = self.currency.storageCurrency
        let storageCategoty = StorageAccount(id: id, name: name, amount: amount, currency: currency, backgroundColor: backgroundColor)
        return storageCategoty
    }
}
