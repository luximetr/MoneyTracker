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
typealias StorageAccount = MoneyTrackerStorage.BalanceAccount

struct Account: Equatable, Hashable {
    
    let id: String
    let name: String
    let amount: Decimal
    let currency: Currency
    let colorHex: String
    
    // MARK: Initializer
    
    init(id: String, name: String, amount: Decimal, currency: Currency, colorHex: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.colorHex = colorHex
    }
    
    // MARK: PresentationCategory
    
    init(presentationAccount: PresentationAccount) throws {
        self.id = presentationAccount.id
        self.name = presentationAccount.name
        self.amount = presentationAccount.amount
        self.currency = Currency(presentationCurrency: presentationAccount.currency)
        let colorConvertor = UIColorHexConvertor()
        self.colorHex = try colorConvertor.convertToHexString(color: presentationAccount.backgroundColor)
    }
    
    func presentationAccount() throws -> PresentationAccount {
        let currency = self.currency.presentationCurrency
        let colorConvertor = UIColorHexConvertor()
        let backgroundColor = try colorConvertor.convertToUIColor(hexString: colorHex)
        let presentationAccount = PresentationAccount(id: id, name: name, amount: amount, currency: currency, backgroundColor: backgroundColor)
        return presentationAccount
    }
    
    // MARK: StorageCategory
    
    init(storageAccount: StorageAccount) {
        self.id = storageAccount.id
        self.name = storageAccount.name
        self.amount = storageAccount.amount
        self.currency = Currency(storageCurrency: storageAccount.currency)
        self.colorHex = storageAccount.colorHex
    }
    
    var storageAccount: StorageAccount {
        let currency = self.currency.storageCurrency
        let storageCategoty = StorageAccount(id: id, name: name, amount: amount, currency: currency, colorHex: colorHex)
        return storageCategoty
    }
}
