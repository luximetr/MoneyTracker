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
    
    func adaptToStorage(presentationExpenseTemplate: PresentationExpenseTemplate) -> StorageExpenseTemplate {
        return StorageExpenseTemplate(
            id: presentationExpenseTemplate.id,
            name: presentationExpenseTemplate.name,
            amount: presentationExpenseTemplate.amount,
            comment: presentationExpenseTemplate.comment,
            balanceAccountId: presentationExpenseTemplate.balanceAccountId,
            categoryId: presentationExpenseTemplate.categoryId
        )
    }
    
    func adaptToPresentation(storageExpenseTemplate: StorageExpenseTemplate) -> PresentationExpenseTemplate {
        return PresentationExpenseTemplate(
            id: storageExpenseTemplate.id,
            name: storageExpenseTemplate.name,
            amount: storageExpenseTemplate.amount,
            comment: storageExpenseTemplate.comment,
            balanceAccountId: storageExpenseTemplate.balanceAccountId,
            categoryId: storageExpenseTemplate.categoryId
        )
    }
}
