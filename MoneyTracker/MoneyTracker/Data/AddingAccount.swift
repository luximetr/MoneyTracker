//
//  AddingAccount.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 15.02.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAddingAccount = MoneyTrackerPresentation.AddingAccount
import MoneyTrackerStorage
import UIKit
typealias StorageAddingAccount = MoneyTrackerStorage.AddingAccount

struct AddingAccount: Equatable, Hashable {
    let name: String
    let balance: Decimal
    let currencyCode: String
    let backgroundColor: Data
    
    init(name: String, balance: Decimal, currencyCode: String, backgroundColor: Data) {
        self.name = name
        self.balance = balance
        self.currencyCode = currencyCode
        self.backgroundColor = backgroundColor
    }
    
    // MARK: PresentationCategory
    
    init(presentationAddingAccount: PresentationAddingAccount) {
        self.name = presentationAddingAccount.name
        self.balance = presentationAddingAccount.balance.amount
        self.currencyCode = presentationAddingAccount.balance.currency.rawValue
        self.backgroundColor = try! NSKeyedArchiver.archivedData(withRootObject: presentationAddingAccount.backgroundColor, requiringSecureCoding: false)
    }
    
    var presentationAddingAccount: PresentationAddingAccount {
        let currency = PresentationCurrency(rawValue: currencyCode)!
        let backgroundColor = (try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self.backgroundColor))!
        let balance = Balance(amount: balance, currency: currency)
        let presentationAddingAccount = PresentationAddingAccount(name: name, balance: balance, backgroundColor: backgroundColor)
        return presentationAddingAccount
    }
    
    // MARK: StorageCategory
    
    init(storageAddingAccount: StorageAddingAccount) {
        self.name = storageAddingAccount.name
        self.balance = storageAddingAccount.balance
        self.currencyCode = storageAddingAccount.currency.rawValue
        self.backgroundColor = storageAddingAccount.backgroundColor
    }
    
    var storageAddingAccount: StorageAddingAccount {
        let currency = StorageCurrency(rawValue: currencyCode)!
        let storageAddingCategoty = StorageAddingAccount(name: name, balance: balance, currency: currency, backgroundColor: backgroundColor)
        return storageAddingCategoty
    }
}
