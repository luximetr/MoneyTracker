//
//  BalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation

public struct BalanceAccount {
    let id: String
    let name: String
    let currencyISOCode: String
    
    init(id: String, name: String, currencyISOCode: String) {
        self.id = id
        self.name = name
        self.currencyISOCode = currencyISOCode
    }
    
    init(addingBalanceAccount: AddingBalanceAccount) {
        self.id = UUID().uuidString
        self.name = addingBalanceAccount.name
        self.currencyISOCode = addingBalanceAccount.currencyISOCode
    }
}

typealias BalanceAccountId = String
