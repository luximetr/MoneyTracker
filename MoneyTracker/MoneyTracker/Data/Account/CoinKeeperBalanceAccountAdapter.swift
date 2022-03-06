//
//  CoinKeeperBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 06.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesCoinKeeperBalanceAccount = MoneyTrackerFiles.CoinKeeperBalanceAccount

class CoinKeeperBalanceAccountAdapter {
    
    func adaptToStorageAddings(filesCoinKeeperBalanceAccounts: [FilesCoinKeeperBalanceAccount]) -> [StorageAddingAccount] {
        return filesCoinKeeperBalanceAccounts.compactMap {
            do {
                return try adaptToStorageAdding(filesCoinKeeperBalanceAccount: $0)
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    func adaptToStorageAdding(filesCoinKeeperBalanceAccount: FilesCoinKeeperBalanceAccount) throws -> StorageAddingAccount {
        let currency = try StorageCurrency(filesCoinKeeperBalanceAccount.currency)
        return StorageAddingAccount(
            name: filesCoinKeeperBalanceAccount.name,
            amount: filesCoinKeeperBalanceAccount.amount,
            currency: currency,
            backgroundColor: Data()
        )
    }
}
