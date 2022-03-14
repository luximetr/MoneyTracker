//
//  Expense.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationExpense = MoneyTrackerPresentation.Expense
import MoneyTrackerStorage
typealias StorageExpense = MoneyTrackerStorage.Expense

struct Expense: Equatable, Hashable {
    
    let id: String
    let amount: Decimal
    let date: Date
    let comment: String?
    let balanceAccountId: String
    let categoryId: String
    
}
