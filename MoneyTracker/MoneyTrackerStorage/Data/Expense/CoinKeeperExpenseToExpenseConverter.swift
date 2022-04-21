//
//  CoinKeeperExpenseToExpenseConverter.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 02.03.2022.
//

import Foundation

class CoinKeeperExpenseToExpenseConverter {
    
    func convert(
        coinKeeperExpenses: [CoinKeeperExpense],
        categories: [Category],
        balanceAccounts: [BalanceAccount]
    ) -> [Expense] {
        let expenses = coinKeeperExpenses.compactMap {
            return convert(
                coinKeeperExpense: $0,
                categories: categories,
                balanceAccounts: balanceAccounts
            )
        }
        return expenses
    }
    
    private func convert(
        coinKeeperExpense: CoinKeeperExpense,
        categories: [Category],
        balanceAccounts: [BalanceAccount]
    ) -> Expense? {
        do {
            return try tryConvert(
                coinKeeperExpense: coinKeeperExpense,
                categories: categories,
                balanceAccounts: balanceAccounts
            )
        } catch {
            print(error)
            return nil
        }
    }
    
    private func tryConvert(
        coinKeeperExpense: CoinKeeperExpense,
        categories: [Category],
        balanceAccounts: [BalanceAccount]
    ) throws -> Expense {
        let category = try findCategory(categories: categories, byName: coinKeeperExpense.category)
        let balanceAccount = try findBalanceAccount(accounts: balanceAccounts, byName: coinKeeperExpense.balanceAccount)
        return Expense(
            coinKeeperExpense: coinKeeperExpense,
            balanceAccountId: balanceAccount.id,
            categoryId: category.id
        )
    }
    
    private func findCategory(categories: [Category], byName name: String) throws -> Category {
        let category = categories.first(where: {
            $0.name.lowercased() == name.lowercased()
        })
        guard let category = category else {
            throw ConvertError.noCategoryFound
        }
        return category
    }
    
    private func findBalanceAccount(accounts: [BalanceAccount], byName name: String) throws -> BalanceAccount {
        let account = accounts.first(where: {
            $0.name.lowercased() == name.lowercased()
        })
        guard let account = account else {
            throw ConvertError.noBalanceAccountFound
        }
        return account

    }
    
    enum ConvertError: Swift.Error {
        case noCategoryFound
        case noBalanceAccountFound
    }
}
