//
//  ExpenseTemplateAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationExpenseTemplate = MoneyTrackerPresentation.ExpenseTemplate
typealias StorageExpenseTemplate = MoneyTrackerStorage.ExpenseTemplate

class ExpenseTemplateAdapter {
    
    func adaptToStorage(presentationExpenseTemplate: PresentationExpenseTemplate, balanceAccount: BalanceAccount, category: StorageCategory) -> StorageExpenseTemplate {
        return StorageExpenseTemplate(
            id: presentationExpenseTemplate.id,
            name: presentationExpenseTemplate.name,
            amount: presentationExpenseTemplate.amount,
            comment: presentationExpenseTemplate.comment,
            balanceAccountId: presentationExpenseTemplate.balanceAccount.id,
            categoryId: presentationExpenseTemplate.category.id
        )
    }
    
    func adaptToPresentation(
        storageExpenseTemplate: StorageExpenseTemplate,
        presentationBalanceAccount: BalanceAccount,
        presentationCategory: PresentationCategory
    ) -> PresentationExpenseTemplate {
        return PresentationExpenseTemplate(
            id: storageExpenseTemplate.id,
            name: storageExpenseTemplate.name,
            amount: storageExpenseTemplate.amount,
            comment: storageExpenseTemplate.comment,
            balanceAccount: PresentationAccount(id: "", name: "", amount: 0, currency: .sgd, backgroundColor: .black),
            category: presentationCategory
        )
    }
}
