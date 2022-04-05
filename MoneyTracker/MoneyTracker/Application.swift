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
    
    func presentationCategories(_ presentation: Presentation) throws -> [PresentationCategory] {
        do {
            let storageCategories = try storage.getCategoriesOrdered()
            let categories = storageCategories.map({ Category(storageCategory: $0) })
            let presentationCategories = categories.map({ $0.presentationCategory })
            return presentationCategories
        } catch {
            let error = Error("Cannot get categories\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, addCategory addingCategory: PresentationAddingCategory) throws -> PresentationCategory {
        do {
            let storageAddingCategory = AddingCategory(presentationAddingCategory: addingCategory).storageAddingCategoty
            let storageAddedCategory = try storage.addCategory(storageAddingCategory)
            let presentationAddedCategory = Category(storageCategory: storageAddedCategory).presentationCategory
            return presentationAddedCategory
        } catch {
            let error = Error("Cannot add category \(addingCategory)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteCategory category: PresentationCategory) throws {
        do {
            let storageCategory = Category(presentationCategory: category).storageCategoty
            try storage.removeCategory(id: storageCategory.id)
        } catch {
            let error = Error("Cannot delete category \(category)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editCategory presentationCategory: PresentationCategory) throws -> PresentationCategory {
        do {
            let editingCategory = EditingCategory(name: presentationCategory.name)
            try storage.updateCategory(id: presentationCategory.id, editingCategory: editingCategory)
            return presentationCategory
        } catch {
            let error = Error("Cannot edit category \(presentationCategory)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, orderCategories categories: [PresentationCategory]) throws {
        do {
            try storage.saveCategoriesOrder(orderedIds: categories.map({ $0.id }))
        } catch {
            let error = Error("Cannot order categories \(categories)\n\(error)")
            throw error
        }
    }
    
    func presentationAccounts(_ presentation: Presentation) throws -> [PresentationAccount] {
        do {
            let storageAccounts = try storage.getAllBalanceAccountsOrdered()
            let presentationAccounts = try storageAccounts.map({ try Account(storageAccount: $0).presentationAccount() })
            return presentationAccounts
        } catch {
            let error = Error("Cannot get accounts\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, addAccount addingAccount: PresentationAddingAccount) throws -> PresentationAccount {
        do {
            let storageAddingAccount = AddingAccount(presentationAddingAccount: addingAccount).storageAddingAccount
            let addedStorageAccount = try storage.addBalanceAccount(storageAddingAccount)
            let addedPresentationAccount = try Account(storageAccount: addedStorageAccount).presentationAccount()
            return addedPresentationAccount
        } catch {
            let error = Error("Cannot add account \(addingAccount)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteAccount deletingAccount: PresentationAccount) throws {
        do {
            let storageAccount = try Account(presentationAccount: deletingAccount).storageAccount
            try storage.removeBalanceAccount(id: storageAccount.id)
        } catch {
            let error = Error("Cannot delete account \(deletingAccount)\n\(error)")
            throw error
        }
    }

    func presentation(_ presentation: Presentation, orderAccounts accounts: [PresentationAccount]) throws {
        do {
            let storageAccounts = try accounts.map({ try Account(presentationAccount: $0).storageAccount })
            let orderedIds = storageAccounts.map({ $0.id })
            try storage.saveBalanceAccountOrder(orderedIds: orderedIds)
        } catch {
            let error = Error("Cannot order accounts \(accounts)\n\(error)")
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
            let error = Error("Cannot edit account \(editingAccount)\n\(error)")
            throw error
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
    
    func presentationDayExpenses(_ presentation: Presentation, day: Date) throws -> [PresentationExpense] {
        let categories = try storage.getCategories()
        let accounts = try storage.getAllBalanceAccounts()
        let startDate = day.startOfDay
        let endDate = day.endOfDay
        let expenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
        let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
            guard let storageCategory = categories.first(where: { $0.id == expense.categoryId }) else { throw Error("") }
            guard let storageAccount = accounts.first(where: { $0.id == expense.balanceAccountId }) else { throw Error("") }
            return try Expense(storageExpense: expense, account: storageAccount, category: storageCategory).presentationExpense()
        }
        return presentationExpenses.reversed()
    }
    
    func presentationExpensesMonths(_ presentation: Presentation) -> [Date] {
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 100000000000)
        let expenses = try! storage.getExpenses(startDate: startDate, endDate: endDate)
        let monthsExpenses = Dictionary(grouping: expenses) { $0.date.startOfMonth }
        let months = monthsExpenses.keys.sorted(by: <)
        return months
    }
    
    func presentationMonthExpenses(_ presentation: Presentation, month: Date) throws -> [PresentationExpense] {
        let categories = try storage.getCategories()
        let accounts = try storage.getAllBalanceAccounts()
        let startDate = month.startOfMonth
        let endDate = month.endOfMonth
        let expenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
        let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
            guard let storageCategory = categories.first(where: { $0.id == expense.categoryId }) else { throw Error("") }
            guard let storageAccount = accounts.first(where: { $0.id == expense.balanceAccountId }) else { throw Error("") }
            return try Expense(storageExpense: expense, account: storageAccount, category: storageCategory).presentationExpense()
        }
        return presentationExpenses
    }
    
    func presentationExpenses(_ presentation: Presentation) throws -> [PresentationExpense] {
        let categories = try storage.getCategories()
        let accounts = try storage.getAllBalanceAccounts()
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 100000000000)
        let expenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
        let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
            guard let storageCategory = categories.first(where: { $0.id == expense.categoryId }) else { throw Error("") }
            guard let storageAccount = accounts.first(where: { $0.id == expense.balanceAccountId }) else { throw Error("") }
            return try Expense(storageExpense: expense, account: storageAccount, category: storageCategory).presentationExpense()
        }
        return presentationExpenses.reversed()
    }
    
    func presentation(_ presentation: Presentation, addExpense presentationAddingExpense: PresentationAddingExpense) throws -> PresentationExpense {
        let categories = try storage.getCategories()
        let accounts = try storage.getAllBalanceAccounts()
        let addingExpence = try AddingExpense(presentationAddingExpense: presentationAddingExpense)
        let storageAddingExpense = addingExpence.storageAddingExpense
        let storageAddedExpense = try storage.addExpense(addingExpense: storageAddingExpense)
        guard let storageCategory = categories.first(where: { $0.id == storageAddedExpense.categoryId }) else { throw Error("") }
        guard let storageAccount = accounts.first(where: { $0.id == storageAddedExpense.balanceAccountId }) else { throw Error("") }
        let presentationExpense = try Expense(storageExpense: storageAddedExpense, account: storageAccount, category: storageCategory).presentationExpense()
        return presentationExpense
    }
    
    func presentation(_ presentation: Presentation, editExpense editingExpense: PresentationExpense) throws -> PresentationExpense {
        let storageEditingExpense = MoneyTrackerStorage.EditingExpense(amount: editingExpense.amount, date: editingExpense.date, comment: editingExpense.comment, balanceAccountId: editingExpense.account.id, categoryId: editingExpense.category.id)
        try storage.updateExpense(expenseId: editingExpense.id, editingExpense: storageEditingExpense)
        return editingExpense
    }
    
    // MARK: - ExpenseTemplates
    
    func presentationExpenseTemplates(_ presentation: Presentation) throws -> [PresentationExpenseTemplate] {
        do {
            let adapter = ExpenseTemplateAdapter()
            let storageTemplates = try storage.getAllExpenseTemplatesOrdered()
            let storageCategoriesIds = storageTemplates.map { $0.categoryId }
            let storageBalanceAccountsIds = storageTemplates.map { $0.balanceAccountId }
            let storageCategories = try storage.getCategories(ids: storageCategoriesIds)
            let storageBalanceAccounts = try storage.getBalanceAccounts(ids: storageBalanceAccountsIds)
            let presentationTemplates = storageTemplates.compactMap { storageTemplate -> PresentationExpenseTemplate? in
                guard let storageCategory = storageCategories.first(where: { $0.id == storageTemplate.categoryId }) else { return nil }
                guard let storageBalanceAccount = storageBalanceAccounts.first(where: { $0.id == storageTemplate.balanceAccountId }) else { return nil }
                guard let account = try? Account(storageAccount: storageBalanceAccount).presentationAccount() else { return nil }
                let category = Category(storageCategory: storageCategory).presentationCategory
                return adapter.adaptToPresentation(storageExpenseTemplate: storageTemplate, presentationBalanceAccount: account, presentationCategory: category)
            }
            return presentationTemplates
        } catch {
            let error = Error("Cannot get expense templates\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, addExpenseTemplate addingExpenseTemplate: PresentationAddingExpenseTemplate) throws -> PresentationExpenseTemplate {
        let adapter = AddingExpenseTemplateAdapter()
        let storageAddingTemplate = adapter.adaptToStorage(presentationAddingExpenseTemplate: addingExpenseTemplate)
        do {
            let storageTemplate = try storage.addExpenseTemplate(addingExpenseTemplate: storageAddingTemplate)
            let templateAdapter = ExpenseTemplateAdapter()
            let template = templateAdapter.adaptToPresentation(storageExpenseTemplate: storageTemplate, presentationBalanceAccount: addingExpenseTemplate.balanceAccount, presentationCategory: addingExpenseTemplate.category)
            return template
        } catch {
            let error = Error("Cannot add expense template \(addingExpenseTemplate)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editExpenseTemplate editingExpenseTemplate: PresentationEditingExpenseTemplate) -> PresentationExpenseTemplate {
        let adapter = EditingExpenseTemplateAdapter()
        let storageEditingTemplate = adapter.adaptToStorage(presentationEditingExpenseTemplate: editingExpenseTemplate)
        tryUpdateExpenseTemplate(editingExpenseTemplate: storageEditingTemplate)
        guard let updatedTemplate = tryFetchPresentationExpenseTemplate(id: editingExpenseTemplate.id) else { fatalError() }
        return updatedTemplate
    }
    
    private func tryUpdateExpenseTemplate(editingExpenseTemplate: StorageEditingExpenseTemplate) {
        do {
            try storage.updateExpenseTemplate(editingExpenseTemplate: editingExpenseTemplate)
        } catch {
            print(error)
        }
    }
    
    private func tryFetchPresentationExpenseTemplate(id: String) -> PresentationExpenseTemplate? {
        do {
            return try fetchPresentationExpenseTemplate(id: id)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func fetchPresentationExpenseTemplate(id: String) throws -> PresentationExpenseTemplate {
        let storageExpenseTemplate = try storage.getExpenseTemplate(expenseTemplateId: id)
        let storageCategory = try storage.getCategory(id: storageExpenseTemplate.categoryId)
        let storageBalanceAccount = try storage.getBalanceAccount(id: storageExpenseTemplate.balanceAccountId)
        let presentationCategory = Category(storageCategory: storageCategory).presentationCategory
        let presentationBalanceAccount = try Account(storageAccount: storageBalanceAccount).presentationAccount()
        let presentationExpenseTemplate = ExpenseTemplateAdapter().adaptToPresentation(storageExpenseTemplate: storageExpenseTemplate, presentationBalanceAccount: presentationBalanceAccount, presentationCategory: presentationCategory)
        return presentationExpenseTemplate
    }
    
    private func tryFetchStorageExpenseTemplate(id: String) -> StorageExpenseTemplate? {
        do {
            return try storage.getExpenseTemplate(expenseTemplateId: id)
        } catch {
            print(error)
            return nil
        }
    }
    
    func presentation(_ presentation: Presentation, reorderExpenseTemplates: [PresentationExpenseTemplate]) {
        let orderedIds = reorderExpenseTemplates.map { $0.id }
        trySaveExpenseTemplatesOrder(orderedIds: orderedIds)
    }
    
    private func trySaveExpenseTemplatesOrder(orderedIds: [String]) {
        do {
            try storage.saveExpenseTemplatesOrder(orderedIds: orderedIds)
        } catch {
            print(error)
        }
    }
    
    func presentation(_ presentation: Presentation, deleteExpenseTemplate expenseTemplate: PresentationExpenseTemplate) {
        tryRemoveExpenseTemplate(expenseTemplateId: expenseTemplate.id)
    }
    
    private func tryRemoveExpenseTemplate(expenseTemplateId: String) {
        do {
            try storage.removeExpenseTemplate(expenseTemplateId: expenseTemplateId)
        } catch {
            print(error)
        }
    }
    
    func presentation(_ presentation: Presentation, deleteExpense deletingExpense: PresentationExpense) throws -> PresentationExpense {
        try storage.removeExpense(expenseId: deletingExpense.id)
        return deletingExpense
    }
    
    // MARK: - Files
    
    private lazy var files: Files = {
        let files = Files()
        return files
    }()
    
    func presentation(_ presentation: Presentation, didPickDocumentAt url: URL) {
        guard let importingFile = tryParseExpensesCSV(url: url) else { return }
        let fileAdapter = ImportingExpensesFileAdapter()
        let storageFile = fileAdapter.adaptToStorage(filesImportingExpensesFile: importingFile)
        trySaveImportingExpensesFile(storageFile)
    }
    
    private func parseCoinKeeperCSV(url: URL) -> CoinKeeperFile? {
        do {
            return try files.parseCoinKeeperCSV(url: url)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func trySaveImportingExpensesFile(_ file: StorageImportingExpensesFile) {
        do {
            try storage.saveImportingExpensesFile(file)
        } catch {
            print(error)
        }
    }
    
    private func tryParseExpensesCSV(url: URL) -> MoneyTrackerFiles.ImportingExpensesFile? {
        do {
            return try files.parseExpensesCSV(url: url)
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
    
    func presentationDidStartExpensesCSVExport(_ presentation: Presentation) throws -> URL {
        let categoriesAdapter = ExportCategoryAdapter()
        let storageCategories = fetchCategories()
        let filesCategories = storageCategories.map { categoriesAdapter.adaptToFiles(storageCategory: $0) }
        let balanceAccountsAdapter = ExportBalanceAccountAdapter()
        let storageBalanceAccounts = fetchAllBalanceAccounts()
        let filesBalanceAccounts = storageBalanceAccounts.map { balanceAccountsAdapter.adaptToFiles(storageAccount: $0) }
        let expensesAdapter = ExportExpenseAdapter()
        let storageExpenses = fetchAllExpenses()
        let filesExpenses = storageExpenses.compactMap { storageExpense -> FilesExportExpense? in
            guard let category = filesCategories.first(where: { $0.id == storageExpense.categoryId }) else { return nil }
            guard let account = filesBalanceAccounts.first(where: { $0.id == storageExpense.balanceAccountId }) else { return nil }
            return expensesAdapter.adaptToFiles(storageExpense: storageExpense, balanceAccount: account, category: category)
        }
        let exportFile = ExportExpensesFile(
            balanceAccounts: filesBalanceAccounts,
            categories: filesCategories,
            expenses: filesExpenses
        )
        let fileURL = try files.createCSVFile(exportExpensesFile: exportFile)
        return fileURL
    }
    
    private func fetchAllExpenses() -> [MoneyTrackerStorage.Expense] {
        do {
            return try storage.getAllExpenses()
        } catch {
            print(error)
            return []
        }
    }
    
    private func fetchCategories() -> [StorageCategory] {
        do {
            return try storage.getCategoriesOrdered()
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
    
    private func fetchAllBalanceAccounts() -> [BalanceAccount] {
        do {
            return try storage.getAllBalanceAccounts()
        } catch {
            print(error)
            return []
        }
    }
    
    func presentation(_ presentation: Presentation, useTemplate template: PresentationExpenseTemplate) throws -> PresentationExpense {
        let amount = template.amount
        let date = Date()
        let component = template.comment
        let account = try Account(presentationAccount: template.balanceAccount)
        let category = Category(presentationCategory: template.category)
        let addingExpense = AddingExpense(amount: amount, date: date, comment: component, account: account, category: category)
        let storageaAddingExpense = addingExpense.storageAddingExpense
        let storageExpense = try storage.addExpense(addingExpense: storageaAddingExpense)
        let storageCategory = category.storageCategoty
        let storageAccount = account.storageAccount
        let expense = Expense(storageExpense: storageExpense, account: storageAccount, category: storageCategory)
        return try expense.presentationExpense()
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}
