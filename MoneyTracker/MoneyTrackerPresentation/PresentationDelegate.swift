//
//  PresentationDelegate.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.04.2022.
//

import Foundation

public protocol PresentationDelegate: AnyObject {
    func presentationCategories(_ presentation: Presentation) throws -> [Category]
    func presentation(_ presentation: Presentation, addCategory addingCategory: AddingCategory) throws -> Category
    func presentation(_ presentation: Presentation, editCategory editingCategory: EditingCategory) throws -> Category
    func presentation(_ presentation: Presentation, deleteCategory category: Category) throws
    func presentation(_ presentation: Presentation, orderCategories categories: [Category]) throws
    func presentationCurrencies(_ presentation: Presentation) -> [Currency]
    func presentationSelectedCurrency(_ presentation: Presentation) throws -> Currency
    func presentation(_ presentation: Presentation, updateSelectedCurrency currency: Currency)
    func presentationAccounts(_ presentation: Presentation) throws -> [Account]
    func presentation(_ presentation: Presentation, deleteAccount category: Account) throws
    func presentation(_ presentation: Presentation, addAccount addingAccount: AddingAccount) throws -> Account
    func presentation(_ presentation: Presentation, editAccount editingAccount: EditingAccount) throws -> Account
    func presentation(_ presentation: Presentation, orderAccounts accounts: [Account]) throws
    func presentationExpenseTemplates(_ presentation: Presentation) throws -> [ExpenseTemplate]
    func presentation(_ presentation: Presentation, reorderExpenseTemplates reorderedExpenseTemplates: [ExpenseTemplate]) throws
    func presentation(_ presentation: Presentation, deleteExpenseTemplate expenseTemplate: ExpenseTemplate) throws
    func presentation(_ presentation: Presentation, addExpenseTemplate addingExpenseTemplate: AddingExpenseTemplate) throws -> ExpenseTemplate
    func presentation(_ presentation: Presentation, editExpenseTemplate editingExpenseTemplate: EditingExpenseTemplate) throws -> ExpenseTemplate
    func presentation(_ presentation: Presentation, didPickDocumentAt url: URL) throws
    func presentationDidStartExpensesCSVExport(_ presentation: Presentation) throws -> URL
    func presentationDayExpenses(_ presentation: Presentation, day: Date) throws -> [Expense]
    func presentation(_ presentation: Presentation, addExpense addingExpense: AddingExpense) throws -> Expense
    func presentation(_ presentation: Presentation, editExpense editingExpense: Expense) throws -> Expense
    func presentation(_ presentation: Presentation, deleteExpense deletingExpense: Expense) throws -> Expense
    func presentationExpenses(_ presentation: Presentation) throws -> [Expense]
    func presentationMonthExpenses(_ presentation: Presentation, month: Date) throws -> [Expense]
    func presentationExpensesMonths(_ presentation: Presentation) throws -> [Date]
    func presentation(_ presentation: Presentation, useTemplate tempalate: ExpenseTemplate) throws -> Expense
    func presentation(_ presentation: Presentation, addTransfer addingTransfer: AddingTransfer) throws -> Transfer
    func presentation(_ presentation: Presentation, addTopUpAccount addingTopUpAccount: AddingReplenishment) throws -> Replenishment
    
    func presentationLanguages(_ presentation: Presentation) throws -> [Language]
    func presentationLanguage(_ presentation: Presentation) throws -> Language
    func presentation(_ presentation: Presentation, selectLanguage language: Language) throws
    
    func presentationAppearanceSetting(_ presentation: Presentation) throws -> AppearanceSetting
    func presentation(_ presentation: Presentation, selectAppearanceSetting appearanceSetting: AppearanceSetting) throws
    
    func presentationOperations(_ presentation: Presentation) throws -> [Operation]
    
    func presentation(_ presentation: Presentation, deleteBalanceTransfer deletingBalanceTransfer: Transfer) throws -> Transfer
    
    func presentation(_ presentation: Presentation, deleteBalanceReplenishment deletingBalanceReplenishment: Replenishment) throws -> Replenishment
    func presentation(_ presentation: Presentation, editReplenishment editingReplenishment: EditingReplenishment) throws -> Replenishment
}
