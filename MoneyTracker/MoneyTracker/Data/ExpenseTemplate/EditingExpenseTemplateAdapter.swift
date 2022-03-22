//
//  EditingExpenseTemplateAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 20.03.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationEditingExpenseTemplate = MoneyTrackerPresentation.EditingExpenseTemplate
typealias StorageEditingExpenseTemplate = MoneyTrackerStorage.EditingExpenseTemplate

class EditingExpenseTemplateAdapter {
    
    func adaptToStorage(presentationEditingExpenseTemplate: PresentationEditingExpenseTemplate) -> StorageEditingExpenseTemplate {
        return StorageEditingExpenseTemplate(
            id: presentationEditingExpenseTemplate.id,
            name: presentationEditingExpenseTemplate.name,
            amount: presentationEditingExpenseTemplate.amount,
            comment: presentationEditingExpenseTemplate.comment,
            balanceAccountId: presentationEditingExpenseTemplate.balanceAccountId,
            categoryId: presentationEditingExpenseTemplate.categoryId
        )
    }
}
