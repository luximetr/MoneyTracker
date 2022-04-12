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
import MoneyTrackerUIKit

struct AddingAccount: Equatable, Hashable {
    
    let name: String
    let amount: Decimal
    let currency: Currency
    let colorHex: String
    
    init(name: String, amount: Decimal, currency: Currency, colorHex: String) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.colorHex = colorHex
    }
    
    // MARK: PresentationCategory
    
    init(presentationAddingAccount: PresentationAddingAccount) throws {
        do {
            self.name = presentationAddingAccount.name
            self.amount = presentationAddingAccount.amount
            self.currency = Currency(presentationCurrency: presentationAddingAccount.currency)
            let colorConvertor = UIColorHexConvertor()
            self.colorHex = try colorConvertor.convertToHexString(color: presentationAddingAccount.backgroundColor)
        } catch {
            let error = Error("Cannot initialize\n\(error)")
            throw error
        }
    }
    
    func presentationAddingAccount() throws -> PresentationAddingAccount {
        let currency = currency.presentationCurrency
        let colorConvertor = UIColorHexConvertor()
        let backgroundColor = try colorConvertor.convertToUIColor(hexString: storageAddingAccount.colorHex)
        let presentationAddingAccount = PresentationAddingAccount(name: name, amount: amount, currency: currency, backgroundColor: backgroundColor)
        return presentationAddingAccount
    }
    
    // MARK: StorageCategory
    
    init(storageAddingAccount: StorageAddingAccount) {
        self.name = storageAddingAccount.name
        self.amount = storageAddingAccount.amount
        self.currency = Currency(storageCurrency: storageAddingAccount.currency)
        self.colorHex = storageAddingAccount.colorHex
    }
    
    var storageAddingAccount: StorageAddingAccount {
        let currency = currency.storageCurrency
        let storageAddingCategoty = StorageAddingAccount(name: name, amount: amount, currency: currency, colorHex: colorHex)
        return storageAddingCategoty
    }
}
