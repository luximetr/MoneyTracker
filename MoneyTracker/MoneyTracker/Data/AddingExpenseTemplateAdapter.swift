//
//  AddingExpenseTemplateAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationAddingExpenseTemplate = MoneyTrackerPresentation.AddingExpenseTemplate
typealias StorageAddingExpenseTemplate = MoneyTrackerStorage.AddingExpenseTemplate

class AddingExpenseTemplateAdapter {
    
    func adaptToStorage(presentationAddingExpenseTemplate: PresentationAddingExpenseTemplate) -> StorageAddingExpenseTemplate {
        return StorageAddingExpenseTemplate(
            name: presentationAddingExpenseTemplate.name,
            amount: presentationAddingExpenseTemplate.amount,
            comment: presentationAddingExpenseTemplate.comment,
            balanceAccountId: presentationAddingExpenseTemplate.balanceAccountId,
            categoryId: presentationAddingExpenseTemplate.categoryId
        )
    }
    
    func adaptToPresentation(storageAddingExpenseTemplate: StorageAddingExpenseTemplate) -> PresentationAddingExpenseTemplate {
        return PresentationAddingExpenseTemplate(
            name: storageAddingExpenseTemplate.name,
            amount: storageAddingExpenseTemplate.amount,
            comment: storageAddingExpenseTemplate.comment,
            balanceAccountId: storageAddingExpenseTemplate.balanceAccountId,
            categoryId: storageAddingExpenseTemplate.categoryId
        )
    }
}
