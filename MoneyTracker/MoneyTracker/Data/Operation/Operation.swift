//
//  Operation.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import Foundation
import MoneyTrackerStorage
import MoneyTrackerPresentation

typealias StorageOperation = MoneyTrackerStorage.Operation
typealias PresentationOperation = MoneyTrackerPresentation.Operation

class OperationAdapter {
    
    private let storage: Storage
    private let categoryAdapter = CategoryAdapter()
    private let accountAdapter = BalanceAccountAdapter()
    private let expenseAdapter: ExpenseAdapter
    private let transferAdapter = TransferAdapter()
    
    init(storage: Storage) {
        self.storage = storage
        self.expenseAdapter = ExpenseAdapter(storage: storage)
    }
    
    func adaptToPresentation(storageOperation: StorageOperation) -> PresentationOperation {
        switch storageOperation {
        case .expense(let storageExpense, let storageCategory, let storageBalanceAccount):
            let presentationCategory = categoryAdapter.adaptToPresentation(storageCategory: storageCategory)
            let presentationBalanceAccount = accountAdapter.adaptToPresentation(storageAccount: storageBalanceAccount)
            let presentationExpense = expenseAdapter.adaptToPresentation(storageExpense: storageExpense, presentationBalanceAccount: presentationBalanceAccount, presentationCategory: presentationCategory)
            let presentationOperation: PresentationOperation = .expense(presentationExpense)
            return presentationOperation
        case .balanceReplenishment(let storageBalanceReplenishment, let storageBalanceAccount):
            let presentationBalanceAccount = accountAdapter.adaptToPresentation(storageAccount: storageBalanceAccount)
            let presentationBalanceReplenishment = PresentationReplenishment(id: storageBalanceReplenishment.id, timestamp: storageBalanceReplenishment.timestamp, account: presentationBalanceAccount, amount: storageBalanceReplenishment.amount, comment: storageBalanceReplenishment.comment)
            let presentationOperation: PresentationOperation = .replenishment(presentationBalanceReplenishment)
            return presentationOperation
        case .balanceTransfer(let storageBalanceTransfer, let storageFromBalanceAccount, let storageToBalanceAccount):
            let presentationFromBalanceAccount = accountAdapter.adaptToPresentation(storageAccount: storageFromBalanceAccount)
            let presentationToBalanceAccount = accountAdapter.adaptToPresentation(storageAccount: storageToBalanceAccount)
            let presentationBalanceTransfer = transferAdapter.adaptToPresentation(storageTransfer: storageBalanceTransfer, fromPresentationAccount: presentationFromBalanceAccount, toPresentationAccount: presentationToBalanceAccount)
            let presentationOperation: PresentationOperation = .transfer(presentationBalanceTransfer)
            return presentationOperation
        }
    }
}
