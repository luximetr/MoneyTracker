//
//  Application.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit
import MoneyTrackerPresentation
typealias Presentation = MoneyTrackerPresentation.Presentation
typealias PresentationDelegate = MoneyTrackerPresentation.PresentationDelegate
import MoneyTrackerStorage
typealias Storage = MoneyTrackerStorage.Storage
import MoneyTrackerFiles
typealias Files = MoneyTrackerFiles.Files

class Application: AUIEmptyApplication, PresentationDelegate {
    
    // MARK: Events
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        presentation.display()
    }
    
    private func getUOBBalanceAccount() -> BalanceAccount {
        return findBalanceAccount(name: "UOB")
    }
    
    private func getDBSBalanceAccount() -> BalanceAccount {
        return findBalanceAccount(name: "DBS")
    }
    
    private func findBalanceAccount(name: String) -> BalanceAccount {
        if let account = fetchBalanceAccount(name: name) {
            return account
        } else {
            return BalanceAccount(id: "mockUOBId", name: name, amount: Decimal(0), currency: .sgd, backgroundColor: Data())
        }
    }
    
    private func fetchBalanceAccount(name: String) -> BalanceAccount? {
        do {
            let accounts = try storage.getAllBalanceAccounts()
            return accounts.first(where: { $0.name == name })
        } catch {
            return nil
        }
    }
    
    private func findCategory(name: String) -> StorageCategory {
        if let category = fetchCategory(name: name) {
            return category
        } else {
            return StorageCategory(id: "mockHouseId", name: name)
        }
    }
    
    private func fetchCategory(name: String) -> StorageCategory? {
        do {
            let categories = try storage.getCategories()
            return categories.first(where: { $0.name == name })
        } catch {
            return nil
        }
    }
    
    private func saveCategory(_ category: StorageCategory) {
        try? storage.addCategory(MoneyTrackerStorage.AddingCategory(name: category.name))
    }
    
    private func saveAccount(_ account: BalanceAccount) {
        _ = try? storage.addBalanceAccount(AddingBalanceAccount(name: account.name, amount: account.amount, currency: account.currency, backgroundColor: account.backgroundColor))
    }
    
    // MARK: Storage
    
    private lazy var storage: Storage = {
        let storage = Storage()
        return storage
    }()
    
    // MARK: Presentation
    
    private lazy var presentationWindow: UIWindow = {
        let window = self.window ?? UIWindow()
        window.makeKeyAndVisible()
        return window
    }()
    
    private lazy var presentation: Presentation = {
        let presentation = Presentation(window: presentationWindow)
        presentation.delegate = self
        return presentation
    }()
    
    func presentationCategories(_ presentation: Presentation) -> [PresentationCategory] {
        let storageCategories = fetchCategories()
        let categories = storageCategories.map({ Category(storageCategoty: $0) })
        let presentationCategories = categories.map({ $0.presentationCategory })
        return presentationCategories
    }
    
    private func fetchCategories() -> [StorageCategory] {
        do {
            return try storage.getOrderedCategories()
        } catch {
            print(error)
            do {
                return try storage.getCategories()
            } catch {
                print(error)
                return []
            }
        }
    }
    
    func presentation(_ presentation: Presentation, addCategory addingCategory: PresentationAddingCategory) {
        do {
            let storageAddingCategory = AddingCategory(presentationAddingCategory: addingCategory).storageAddingCategoty
            try storage.addCategory(storageAddingCategory)
        } catch {
            print(error)
        }
    }
    
    func presentation(_ presentation: Presentation, deleteCategory category: PresentationCategory) {
        do {
            let storageCategory = Category(presentationCategory: category).storageCategoty
            try storage.removeCategory(id: storageCategory.id)
        } catch {
            print(error)
        }
    }
    
    func presentation(_ presentation: Presentation, sortCategories categories: [PresentationCategory]) {
        do {
            try storage.saveCategoriesOrder(orderedIds: categories.map({ $0.id }))
        } catch {
            print(error)
        }
    }
    
    func presentation(_ presentation: Presentation, editCategory presentationCategory: PresentationCategory) {
        do {
            let editingCategory = EditingCategory(name: presentationCategory.name)
            try storage.updateCategory(id: presentationCategory.id, editingCategory: editingCategory)
        } catch {
            print(error)
        }
    }
    
    func presentationAccounts(_ presentation: Presentation) throws -> [PresentationAccount] {
        do {
            let storageAccounts = try storage.getOrderedBalanceAccounts()
            let presentationAccounts = try storageAccounts.map({ try Account(storageAccount: $0).presentationAccount() })
            return presentationAccounts
        } catch {
            throw error
        }
    }
    
    func presentationAccountBackgroundColors(_ presentation: Presentation) -> [UIColor] {
        let backgroundColors: [UIColor] = [.red, .green, .yellow, .blue, .brown, .cyan]
        return backgroundColors
    }
    
    func presentation(_ presentation: Presentation, addAccount addingAccount: PresentationAddingAccount) throws -> PresentationAccount {
        do {
            let storageAddingAccount = AddingAccount(presentationAddingAccount: addingAccount).storageAddingAccount
            let addedStorageAccount = try storage.addBalanceAccount(storageAddingAccount)
            let addedPresentationAccount = try Account(storageAccount: addedStorageAccount).presentationAccount()
            return addedPresentationAccount
        } catch {
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteAccount account: PresentationAccount) throws {
        do {
            let storageAccount = try Account(presentationAccount: account).storageAccount
            try storage.removeBalanceAccount(id: storageAccount.id)
        } catch {
            throw error
        }
    }

    func presentation(_ presentation: Presentation, orderAccounts accounts: [PresentationAccount]) throws {
        do {
            let storageAccounts = try accounts.map({ try Account(presentationAccount: $0).storageAccount })
            let orderedIds = storageAccounts.map({ $0.id })
            try storage.saveBalanceAccountOrder(orderedIds: orderedIds)
        } catch {
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editAccount editingAccount: PresentationAccount) throws -> PresentationAccount {
        do {
            let storageAccount = try Account(presentationAccount: editingAccount).storageAccount
            let editingBalanceAccount = EditingBalanceAccount(name: storageAccount.name, currency: storageAccount.currency, amount: storageAccount.amount, backgroundColor: storageAccount.backgroundColor)
            try storage.updateBalanceAccount(id: editingAccount.id, editingBalanceAccount: editingBalanceAccount)
            return editingAccount
        } catch {
            throw error
        }
    }
    
    private func fetchAllBalanceAccounts() -> [BalanceAccount] {
        do {
            return try storage.getAllBalanceAccounts()
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - Currencies
    
    func presentationCurrencies(_ presentation: Presentation) -> [PresentationCurrency] {
        return [.sgd, .usd, .uah]
    }
    
    // MARK: - Selected currency
    
    private var selectedCurrency: StorageCurrency?
    
    private func fetchSelectedCurrency() -> StorageCurrency? {
        do {
            return try storage.getSelectedCurrency()
        } catch {
            print(error)
            return nil
        }
    }
    
    func presentationSelectedCurrency(_ presentation: Presentation) -> PresentationCurrency {
        let adapter = CurrencyAdapter()
        let selectedCurrency = self.selectedCurrency ?? fetchSelectedCurrency() ?? .sgd
        self.selectedCurrency = selectedCurrency
        return adapter.adaptToPresentationCurrency(storageCurrency: selectedCurrency)
    }
    
    func presentation(_ presentation: Presentation, updateSelectedCurrency currency: PresentationCurrency) {
        let adapter = CurrencyAdapter()
        let storageCurrency = adapter.adaptToStorageCurrency(presentationCurrency: currency)
        self.selectedCurrency = storageCurrency
        storage.saveSelectedCurrency(storageCurrency)
    }
    
    // MARK: - Expenses
    
    func presentation(_ presentation: Presentation, searchExpensesFrom fromDate: Date, toDate: Date) {
        let expenses = fetchExpenses(from: fromDate, to: toDate)
        let result = expenses.reduce(0) { partialResult, expense in
            partialResult + expense.amount
        }
        presentation.showStatisticTotalSpent(result)
    }
    
    private func fetchExpenses(from startDate: Date, to endDate: Date) -> [Expense] {
        do {
            return try storage.getExpenses(startDate: startDate, endDate: endDate)
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - ExpenseTemplates
    
    func presentationExpenseTemplates(_ presentation: Presentation) -> [PresentationExpenseTemplate] {
//        let adapter = ExpenseTemplateAdapter()
//        let storageTemplates = fetchAllStorageExpenseTemplates()
//        let presentationTemplates = storageTemplates.map { adapter.adaptToPresentation(storageExpenseTemplate: $0) }
//        return presentationTemplates
        return []
    }
    
    private func fetchAllStorageExpenseTemplates() -> [StorageExpenseTemplate] {
        do {
            return try storage.getAllExpenseTemplatesOrdered()
        } catch {
            print(error)
            return []
        }
    }
    
    func presentation(_ presentation: Presentation, addExpenseTemplate addingExpenseTemplate: PresentationAddingExpenseTemplate) {
        let adapter = AddingExpenseTemplateAdapter()
        let storageAddingTemplate = adapter.adaptToStorage(presentationAddingExpenseTemplate: addingExpenseTemplate)
        do {
            try storage.addExpenseTemplate(addingExpenseTemplate: storageAddingTemplate)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Files
    
    private lazy var files: Files = {
        let files = Files()
        return files
    }()
    
    func presentation(_ presentation: Presentation, didPickDocumentAt url: URL) {
        guard let file = parseCoinKeeperCSV(url: url) else { return }
        let categoryAdapter = CoinKeeperCategoryAdapter()
        let addingCategories = file.categories.map { categoryAdapter.adaptToStorageAdding(filesCoinKeeperCategory: $0) }
        storage.addCategories(addingCategories)
        let balanceAccountAdapter = CoinKeeperBalanceAccountAdapter()
        let addingAccounts = balanceAccountAdapter.adaptToStorageAddings(filesCoinKeeperBalanceAccounts: file.balanceAccounts)
        storage.addBalanceAccounts(addingAccounts)
        let expensesAdapter = CoinKeeperExpenseAdapter()
        let coinKeeperExpenses = file.expenses.filter { $0.type == .expense }
        let expenses = coinKeeperExpenses.map { expensesAdapter.adaptToStorage(filesCoinKeeperExpense: $0) }
        addToStorage(coinKeeperExpenses: expenses)
    }
    
    private func parseCoinKeeperCSV(url: URL) -> CoinKeeperFile? {
        do {
            return try files.parseCoinKeeperCSV(url: url)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func addToStorage(coinKeeperExpenses expenses: [StorageCoinKeeperExpense]) {
        do {
            try storage.addExpenses(coinKeeperExpenses: expenses)
        } catch {
            print(error)
        }
    }
    
}
