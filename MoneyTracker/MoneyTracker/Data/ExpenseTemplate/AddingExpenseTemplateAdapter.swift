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
            balanceAccountId: presentationAddingExpenseTemplate.balanceAccount.id,
            categoryId: presentationAddingExpenseTemplate.category.id
        )
    }
}
