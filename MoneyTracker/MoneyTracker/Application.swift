//
//  Application.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit
import MoneyTrackerPresentation
import MoneyTrackerStorage
import MoneyTrackerFiles

typealias Presentation = MoneyTrackerPresentation.Presentation
typealias PresentationDelegate = MoneyTrackerPresentation.PresentationDelegate
typealias Storage = MoneyTrackerStorage.Storage
typealias Files = MoneyTrackerFiles.Files

class Application: AUIEmptyApplication, PresentationDelegate {
    
    // MARK: Events
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        try! initPresentation()
        presentation.display()
    }
    
    // MARK: - Files
    
    private lazy var files: Files = {
        let files = Files()
        return files
    }()
    
    // MARK: - Storage
    
    private lazy var storage: Storage = {
        let storage = Storage()
        return storage
    }()
    
    // MARK: - Presentation
    
    private lazy var presentationWindow: UIWindow = {
        let window = createPresentationWindow()
        self.window = window
        window.makeKeyAndVisible()
        return window
    }()
    
    private var presentation: Presentation!
    
    private func createPresentationWindow() -> UIWindow {
        let window = TraitCollectionChangeNotifyWindow()
        window.didChangeUserInterfaceStyleClosure = { [weak self] style in
            self?.presentation.didChangeUserInterfaceStyle(style)
        }
        return window
    }
    
    private let defaultAppearanceSetting: AppearanceSetting = .system
    private let defaultLanguage: Language = .english
    private func initPresentation() throws {
        do {
            let appearanceSetting: AppearanceSetting
            if let storageAppearanceSetting = try storage.getSelectedAppearanceSetting() {
                appearanceSetting = StorageAppearanceSettingMapper.mapStorageAppearanceSettingToAppearanceSetting(storageAppearanceSetting)
            } else {
                appearanceSetting = defaultAppearanceSetting
            }
            let presentationAppearanceSetting = PresentationAppearanceSettingMapper.mapAppearanceSettingToPresentationAppearanceSetting(appearanceSetting)
            let language: Language
            if let storageLanguage = try storage.getSelectedLanguage() {
                language = StorageLanguageMapper.mapStorageLanguageToLanguage(storageLanguage)
            } else {
                language = .english
            }
            let presentationLanguage = PresentationLanguageMapper.mapLanguageToPresentationLanguage(language)
            let foundationLocaleCurrent = Locale.current
            let foundationLocaleCurrentScriptCode = foundationLocaleCurrent.scriptCode
            let foundationLocaleCurrentRegionCode = foundationLocaleCurrent.regionCode
            let presentationLocale = Locale(language: presentationLanguage, scriptCode: foundationLocaleCurrentScriptCode, regionCode: foundationLocaleCurrentRegionCode)
            let presentation = Presentation(window: presentationWindow, locale: presentationLocale, appearanceSetting: presentationAppearanceSetting)
            presentation.delegate = self
            self.presentation = presentation
        } catch {
            throw Error("Cannot initialize \(String(reflecting: Self.self))")
        }
    }
    
    // MARK: - Categories
    
    func presentationCategories(_ presentation: Presentation) throws -> [PresentationCategory] {
        do {
            let storageCategories = try storage.getCategoriesOrdered()
            let presentationCategories = storageCategories.map { CategoryAdapter().adaptToPresentation(storageCategory: $0) }
            return presentationCategories
        } catch {
            let error = Error("Cannot get categories\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, addCategory addingCategory: PresentationAddingCategory) throws -> PresentationCategory {
        do {
            let storageAddingCategory = AddingCategoryAdapter().adaptToStorage(presentationAddingCategory: addingCategory)
            let storageAddedCategory = try storage.addCategory(storageAddingCategory)
            let presentationAddedCategory = CategoryAdapter().adaptToPresentation(storageCategory: storageAddedCategory)
            return presentationAddedCategory
        } catch {
            let error = Error("Cannot add category \(addingCategory)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteCategory category: PresentationCategory) throws {
        do {
            let storageCategory = CategoryAdapter().adaptToStorage(presentationCategory: category)
            try storage.removeCategory(id: storageCategory.id)
        } catch {
            let error = Error("Cannot delete category \(category)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editCategory presentationEditingCategory: PresentationEditingCategory) throws -> PresentationCategory {
        do {
            let editingCategoryAdapter = EditingCategoryAdapter()
            let storageEditingCategory = try editingCategoryAdapter.adaptToStorage(presentationEditingCategory: presentationEditingCategory)
            let storageEditedCategory = try storage.updateCategory(editingCategory: storageEditingCategory)
            let presentationCategory = CategoryAdapter().adaptToPresentation(storageCategory: storageEditedCategory)
            return presentationCategory
        } catch {
            let error = Error("Cannot edit category \(presentationEditingCategory)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, orderCategories presentationCategories: [PresentationCategory]) throws {
        do {
            let categoryAdapter = CategoryAdapter()
            let storageCategories = presentationCategories.map({ categoryAdapter.adaptToStorage(presentationCategory: $0) })
            try storage.saveCategoriesOrder(orderedIds: storageCategories.map({ $0.id }))
        } catch {
            let error = Error("Cannot order categories \(presentationCategories)\n\(error)")
            throw error
        }
    }
    
    // MARK: - Accounts
    
    func presentationAccounts(_ presentation: Presentation) throws -> [PresentationBalanceAccount] {
        do {
            let storageAccounts = try storage.getAllBalanceAccountsOrdered()
            let accountAdapter = BalanceAccountAdapter()
            let presentationAccounts = storageAccounts.map({ accountAdapter.adaptToPresentation(storageAccount: $0) })
            return presentationAccounts
        } catch {
            let error = Error("Cannot get accounts\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, addAccount addingAccount: PresentationAddingBalanceAccount) throws -> PresentationBalanceAccount {
        do {
            let storageAddingAccount = AddingBalanceAccountAdapter().adaptToStorage(presentationAddingAccount: addingAccount)
            let addedStorageAccount = try storage.addBalanceAccount(storageAddingAccount)
            let addedPresentationAccount = BalanceAccountAdapter().adaptToPresentation(storageAccount: addedStorageAccount)
            return addedPresentationAccount
        } catch {
            let error = Error("Cannot add account \(addingAccount)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteAccount deletingAccount: PresentationBalanceAccount) throws {
        do {
            try storage.removeBalanceAccount(id: deletingAccount.id)
        } catch {
            let error = Error("Cannot delete account \(deletingAccount)\n\(error)")
            throw error
        }
    }

    func presentation(_ presentation: Presentation, orderAccounts presentationBalanceAccounts: [PresentationBalanceAccount]) throws {
        do {
            let balanceAccountAdapter = BalanceAccountAdapter()
            let storageCategories = presentationBalanceAccounts.map({ balanceAccountAdapter.adaptToStorage(presentationAccount: $0) })
            try storage.saveBalanceAccountOrder(orderedIds: storageCategories.map({ $0.id }))
        } catch {
            let error = Error("Cannot order accounts \(presentationBalanceAccounts)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editAccount editingAccount: PresentationEditingBalanceAccount) throws -> PresentationBalanceAccount {
        do {
            let storageEditingAccount = EditingBalanceAccountAdapter().adaptToStorage(presentationEditingAccount: editingAccount)
            let editedStorageAccount = try storage.updateBalanceAccount(editingBalanceAccount: storageEditingAccount)
            let editedPresentationAccount = BalanceAccountAdapter().adaptToPresentation(storageAccount: editedStorageAccount)
            return editedPresentationAccount
        } catch {
            let error = Error("Cannot edit account \(editingAccount)\n\(error)")
            throw error
        }
    }
    
    // MARK: - Currencies
    
    func presentationCurrencies(_ presentation: Presentation) -> [PresentationCurrency] {
        return [.singaporeDollar, .usDollar, .hryvnia, .turkishLira, .baht, .euro]
    }
    
    // MARK: - Selected currency
    
    private var selectedCurrency: StorageCurrency?
    
    func presentationSelectedCurrency(_ presentation: Presentation) throws -> PresentationCurrency {
        do {
            let adapter = CurrencyAdapter()
            let selectedCurrency = try selectedCurrency ?? storage.getSelectedCurrency() ?? .SGD
            self.selectedCurrency = selectedCurrency
            return adapter.adaptToPresentation(storageCurrency: selectedCurrency)
        } catch {
            let error = Error("Cannot get selected currency\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, updateSelectedCurrency currency: PresentationCurrency) {
        let adapter = CurrencyAdapter()
        let storageCurrency = adapter.adaptToStorage(presentationCurrency: currency)
        self.selectedCurrency = storageCurrency
        storage.saveSelectedCurrency(storageCurrency)
    }
    
    // MARK: - Expenses
    
    func presentationDayExpenses(_ presentation: Presentation, day: Date) throws -> [PresentationExpense] {
        do {
            let startDate = day.startOfDay
            let endDate = day.endOfDay
            let expenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
            let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
                return try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: expense)
            }
            return presentationExpenses.reversed()
        } catch {
            let error = Error("Cannot get expenses for day \(day)(\n\(error)")
            throw error
        }
    }
    
    func presentationExpensesMonths(_ presentation: Presentation) throws -> [Date] {
        do {
            let startDate = Date(timeIntervalSince1970: 0)
            let endDate = Date(timeIntervalSince1970: 100000000000)
            let expenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
            let monthsExpenses = Dictionary(grouping: expenses) { $0.date.startOfMonth }
            let months = monthsExpenses.keys.sorted(by: <)
            return months
        } catch {
            let error = Error("Cannot expenses months(\n\(error)")
            throw error
        }
    }
    
    func presentationMonthExpenses(_ presentation: Presentation, month: Date) throws -> [PresentationExpense] {
        do {
            let startDate = month.startOfMonth
            let endDate = month.endOfMonth
            let expenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
            let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
                return try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: expense)
            }
            return presentationExpenses
        } catch {
            let error = Error("Cannot get expenses for month \(month)\n\(error)")
            throw error
        }
    }
    
    func presentationExpenses(_ presentation: Presentation) throws -> [PresentationExpense] {
        do {
            let operations = try storage.getOperations()
            print(operations)
            let expenses = try storage.getAllExpenses()
            let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
                return try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: expense)
            }
            return presentationExpenses.reversed()
        } catch {
            let error = Error("Cannot get expenses\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, addExpense presentationAddingExpense: PresentationAddingExpense) throws -> PresentationExpense {
        do {
            let storageAddingExpense = AddingExpenseAdapter(storage: storage).adaptToStorage(presentationAddingExpense: presentationAddingExpense)
            let storageAddedExpense = try storage.addExpense(addingExpense: storageAddingExpense)
            let presentationExpense = try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: storageAddedExpense)
            return presentationExpense
        } catch {
            let error = Error("Cannot add expense \(presentationAddingExpense)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editExpense editingExpense: PresentationExpense) throws -> PresentationExpense {
        do {
            let currentExpense = try storage.getExpense(id: editingExpense.id)
            let storageEditingExpense = MoneyTrackerStorage.EditingExpense(amount: editingExpense.amount, date: editingExpense.timestamp, comment: editingExpense.comment, balanceAccountId: editingExpense.account.id, categoryId: editingExpense.category.id)
            try storage.updateExpense(expenseId: editingExpense.id, editingExpense: storageEditingExpense)
            if let newAmount = storageEditingExpense.amount {
                let amountDifference = currentExpense.amount - newAmount
                try storage.addBalanceAccountAmount(id: editingExpense.account.id, amount: amountDifference)
            }
            return editingExpense
        } catch {
            let error = Error("Cannot edit expense \(editingExpense)\n\(error)")
            throw error
        }
    }
    
    // MARK: - ExpenseTemplates
    
    func presentationExpenseTemplates(_ presentation: Presentation) throws -> [PresentationExpenseTemplate] {
        do {
            let adapter = ExpenseTemplateAdapter()
            let storageTemplates = try storage.getAllExpenseTemplatesOrdered()
            let storageCategories = try storage.getCategoriesOrdered()
            let storageBalanceAccounts = try storage.getAllBalanceAccountsOrdered()
            let presentationTemplates = storageTemplates.compactMap { storageTemplate -> PresentationExpenseTemplate? in
                guard let storageCategory = storageCategories.first(where: { $0.id == storageTemplate.categoryId }) else { return nil }
                guard let storageBalanceAccount = storageBalanceAccounts.first(where: { $0.id == storageTemplate.balanceAccountId }) else { return nil }
                let account = BalanceAccountAdapter().adaptToPresentation(storageAccount: storageBalanceAccount)
                let category = CategoryAdapter().adaptToPresentation(storageCategory: storageCategory)
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
    
    func presentation(_ presentation: Presentation, editExpenseTemplate editingExpenseTemplate: PresentationEditingExpenseTemplate) throws -> PresentationExpenseTemplate {
        do {
            let adapter = EditingExpenseTemplateAdapter()
            let storageEditingTemplate = adapter.adaptToStorage(presentationEditingExpenseTemplate: editingExpenseTemplate)
            try storage.updateExpenseTemplate(editingExpenseTemplate: storageEditingTemplate)
            let updatedTemplate = try fetchPresentationExpenseTemplate(id: storageEditingTemplate.id)
            return updatedTemplate
        } catch {
            let error = Error("Cannot add expense template \(editingExpenseTemplate)\n\(error)")
            throw error
        }
    }
    
    private func fetchPresentationExpenseTemplate(id: String) throws -> PresentationExpenseTemplate {
        let storageExpenseTemplate = try storage.getExpenseTemplate(expenseTemplateId: id)
        let storageCategory = try storage.getCategory(id: storageExpenseTemplate.categoryId)
        let storageBalanceAccount = try storage.getBalanceAccount(id: storageExpenseTemplate.balanceAccountId)
        let presentationCategory = CategoryAdapter().adaptToPresentation(storageCategory: storageCategory)
        let presentationBalanceAccount = BalanceAccountAdapter().adaptToPresentation(storageAccount: storageBalanceAccount)
        let presentationExpenseTemplate = ExpenseTemplateAdapter().adaptToPresentation(storageExpenseTemplate: storageExpenseTemplate, presentationBalanceAccount: presentationBalanceAccount, presentationCategory: presentationCategory)
        return presentationExpenseTemplate
    }
    
    func presentation(_ presentation: Presentation, reorderExpenseTemplates: [PresentationExpenseTemplate]) throws {
        do {
            let orderedIds = reorderExpenseTemplates.map { $0.id }
            try storage.saveExpenseTemplatesOrder(orderedIds: orderedIds)
        } catch {
            let error = Error("Cannot reorder expense templates\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteExpenseTemplate expenseTemplate: PresentationExpenseTemplate) throws {
        do {
            try storage.removeExpenseTemplate(expenseTemplateId: expenseTemplate.id)
        } catch {
            let error = Error("Cannot delete expense template \(expenseTemplate)\n\(error)")
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteExpense deletingExpense: PresentationExpense) throws -> PresentationExpense {
        let storageDeletingExpense = StorageExpense(id: deletingExpense.id, amount: deletingExpense.amount, date: deletingExpense.timestamp, comment: deletingExpense.comment, balanceAccountId: deletingExpense.account.id, categoryId: deletingExpense.category.id)
        try storage.removeExpense(storageDeletingExpense)
        return deletingExpense
    }
    
    func presentation(_ presentation: Presentation, useTemplate template: PresentationExpenseTemplate) throws -> PresentationExpense {
        let amount = template.amount
        let date = Date()
        let component = template.comment
        let storageaAddingExpense = StorageAddingExpense(amount: amount, date: date, comment: component, balanceAccountId: template.balanceAccount.id, categoryId: template.category.id)
        let storageExpense = try storage.addExpense(addingExpense: storageaAddingExpense)
        let presentationExpense = try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: storageExpense)
        return presentationExpense
    }
    
    // MARK: - Files
    
    func presentation(_ presentation: Presentation, didPickDocumentAt url: URL) throws {
        do {
            let filesImportingFile = try files.parseExpensesCSV(url: url)
            let fileAdapter = ImportingExpensesFileAdapter()
            let storageImportingFile = fileAdapter.adaptToStorage(filesImportingExpensesFile: filesImportingFile)
            let storageImportedFile = try storage.saveImportingExpensesFile(storageImportingFile)
            let importedFileAdapter = ImportedExpensesFileAdapter(storage: storage)
            let presentationImportedFile = try importedFileAdapter.adaptToPresentation(storageImportedExpensesFile: storageImportedFile)
            presentation.showDidImportExpensesFile(presentationImportedFile)
        } catch {
            print(error)
            throw error
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
    
    func presentationDidStartExpensesCSVExport(_ presentation: Presentation) throws -> URL {
        let categoriesAdapter = ExportCategoryAdapter()
        let storageCategories = try storage.getCategoriesOrdered()
        let filesCategories = storageCategories.map { categoriesAdapter.adaptToFiles(storageCategory: $0) }
        let balanceAccountsAdapter = ExportBalanceAccountAdapter()
        let storageBalanceAccounts = try storage.getAllBalanceAccountsOrdered()
        let filesBalanceAccounts = storageBalanceAccounts.map { balanceAccountsAdapter.adaptToFiles(storageAccount: $0) }
        let expensesAdapter = ExportExpenseAdapter()
        let storageExpenses = try storage.getAllExpenses()
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
    
    // MARK: - Transfer
    
    func presentation(_ presentation: Presentation, addTransfer presentationAddingTransfer: PresentationAddingTransfer) throws -> PresentationTransfer {
        do {
            let date = presentationAddingTransfer.timestamp
            let fromBalanceAccountId = presentationAddingTransfer.fromAccount.id
            let fromAmount = Int64(try (presentationAddingTransfer.fromAmount * 100).int())
            let toBalanceAccountId = presentationAddingTransfer.toAccount.id
            let toAmount = Int64(try (presentationAddingTransfer.toAmount * 100).int())
            let comment = presentationAddingTransfer.comment
            let addingBalanceTransfer = AddingTransfer(date: date, fromAccountId: fromBalanceAccountId, fromAmount: fromAmount, toAccountId: toBalanceAccountId, toAmount: toAmount, comment: comment)
            let storageBalanceTransfer = try storage.addBalanceTransfer(addingBalanceTransfer)
            let presentationBalanceTransfer = PresentationTransfer(id: storageBalanceTransfer.id, fromAccount: presentationAddingTransfer.fromAccount, toAccount: presentationAddingTransfer.toAccount, day: presentationAddingTransfer.timestamp, fromAmount: presentationAddingTransfer.fromAmount, toAmount: presentationAddingTransfer.toAmount, comment: presentationAddingTransfer.comment)
            return presentationBalanceTransfer
        } catch {
            let error = Error("Cannot add presentation transfer \(presentationAddingTransfer)\n\(error)")
            throw error
        }
    }
    
    // MARK: - Top Up Account
    
    func presentation(_ presentation: Presentation, addTopUpAccount presentationAddingTopUpAccount: PresentationAddingTopUpAccount) throws -> PresentationTopUpAccount {
        do {
            let timestamp = presentationAddingTopUpAccount.timestamp
            let balanceAccountId = presentationAddingTopUpAccount.account.id
            let amount = Int64(try (presentationAddingTopUpAccount.amount * 100).int())
            let comment = presentationAddingTopUpAccount.comment
            let storageAddingBalanceReplenishment = AddingReplenishment(timestamp: timestamp, accountId: balanceAccountId, amount: amount, comment: comment)
            let storageBalanceTransfer = try storage.addBalanceReplenishment(storageAddingBalanceReplenishment)
            let presentationTopUpAccount = PresentationTopUpAccount(id: storageBalanceTransfer.id, timestamp: presentationAddingTopUpAccount.timestamp, account: presentationAddingTopUpAccount.account, amount: presentationAddingTopUpAccount.amount, comment: presentationAddingTopUpAccount.comment)
            return presentationTopUpAccount
        } catch {
            let error = Error("Cannot add presentation top up account \(presentationAddingTopUpAccount)\n\(error)")
            throw error
        }
    }
    
    // MARK: - Operations
    
    func presentationOperations(_ presentation: Presentation) throws -> [PresentationOperation] {
        let storageOperations = try storage.getOperations()
        let operationAdapter = OperationAdapter(storage: storage)
        let presentationOperations = storageOperations.map { operationAdapter.adaptToPresentation(storageOperation: $0) }
        return presentationOperations
    }
    
    // MARK: - Language
    
    func presentationLanguages(_ presentation: Presentation) throws -> [PresentationLanguage] {
        let languages: [Language] = [.english, .ukrainian, .thai]
        let presentationLanguages = languages.map({ PresentationLanguageMapper.mapLanguageToPresentationLanguage($0) })
        return presentationLanguages
    }
    
    func presentation(_ presentation: Presentation, selectLanguage presentationLanguage: PresentationLanguage) throws {
        let language = PresentationLanguageMapper.mapPresentationLanguageToLanguage(presentationLanguage)
        let storageLanguage = StorageLanguageMapper.mapLanguageToStorageLanguage(language)
        storage.saveSelectedLanguage(storageLanguage)
    }
    
    // MARK: - Appearance
    
    func presentationAppearanceSetting(_ presentation: Presentation) throws -> PresentationAppearanceSetting {
        do {
            let storageAppearanceSetting = (try storage.getSelectedAppearanceSetting()) ?? .system
            let appearanceSetting = StorageAppearanceSettingMapper.mapStorageAppearanceSettingToAppearanceSetting(storageAppearanceSetting)
            let presentationAppearanceSetting = PresentationAppearanceSettingMapper.mapAppearanceSettingToPresentationAppearanceSetting(appearanceSetting)
            return presentationAppearanceSetting
        } catch {
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, selectAppearanceSetting presentationAppearanceSetting: PresentationAppearanceSetting) throws {
        let appearanceSetting = PresentationAppearanceSettingMapper.mapPresentationAppearanceSettingToAppearanceSetting(presentationAppearanceSetting)
        let storageAppearanceSetting = StorageAppearanceSettingMapper.mapAppearanceSettingToStorageAppearanceSetting(appearanceSetting)
        storage.saveSelectedAppearanceSetting(storageAppearanceSetting)
    }
    
    func presentation(_ presentation: Presentation, deleteBalanceTransfer presentationDeletingBalanceTransfer: PresentationTransfer) throws -> PresentationTransfer {
        do {
            let storageBalanceTransfer = StorageBalanceTransfer(id: presentationDeletingBalanceTransfer.id, date: presentationDeletingBalanceTransfer.timestamp, fromAccountId: presentationDeletingBalanceTransfer.fromAccount.id, fromAmount: presentationDeletingBalanceTransfer.fromAmount, toAccountId: presentationDeletingBalanceTransfer.toAccount.id, toAmount: presentationDeletingBalanceTransfer.toAmount, comment: presentationDeletingBalanceTransfer.comment)
            try storage.deleteBalanceTransfer(storageBalanceTransfer)
            return presentationDeletingBalanceTransfer
        } catch {
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, deleteBalanceReplenishment presentationDeletingBalanceReplenishment: PresentationReplenishment) throws -> PresentationReplenishment {
        do {
            let storageBalanceReplenishment = StorageBalanceReplenishment(id: presentationDeletingBalanceReplenishment.id, timestamp: presentationDeletingBalanceReplenishment.timestamp, accountId: presentationDeletingBalanceReplenishment.account.id, amount: presentationDeletingBalanceReplenishment.amount, comment: presentationDeletingBalanceReplenishment.comment)
            try storage.deleteBalanceReplenishment(storageBalanceReplenishment)
            return presentationDeletingBalanceReplenishment
        } catch {
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editReplenishment presentationEditingReplenishment: PresentationEditingReplenishment) throws -> PresentationTopUpAccount {
        do {
            let storageEditingReplenishment = StorageEditingReplenishment(id: presentationEditingReplenishment.id, timestamp: presentationEditingReplenishment.timestamp, accountId: presentationEditingReplenishment.account.id, amount: presentationEditingReplenishment.amount, comment: presentationEditingReplenishment.comment)
            try storage.editReplenishment(storageEditingReplenishment)
            return PresentationTopUpAccount(id: presentationEditingReplenishment.id, timestamp: presentationEditingReplenishment.timestamp, account: presentationEditingReplenishment.account, amount: presentationEditingReplenishment.amount, comment: presentationEditingReplenishment.comment)
        } catch {
            throw error
        }
    }
    
    func presentation(_ presentation: Presentation, editTransfer presentationEditingTransfer: PresentationEditingTransfer) throws -> PresentationTransfer {
        do {
            let storageEditingTransfer = StorageEditingTransfer(id: presentationEditingTransfer.id, timestamp: presentationEditingTransfer.timestamp, fromAccountId: presentationEditingTransfer.fromAccount.id, fromAmount: presentationEditingTransfer.fromAmount, toAccountId: presentationEditingTransfer.toAccount.id, toAmount: presentationEditingTransfer.toAmount, comment: presentationEditingTransfer.comment)
            try storage.editTransfer(storageEditingTransfer)
            let presentationTransfer = PresentationTransfer(id: presentationEditingTransfer.id, fromAccount: presentationEditingTransfer.fromAccount, toAccount: presentationEditingTransfer.toAccount, day: presentationEditingTransfer.timestamp, fromAmount: presentationEditingTransfer.fromAmount, toAmount: presentationEditingTransfer.toAmount, comment: presentationEditingTransfer.comment)
            return presentationTransfer
        } catch {
            throw error
        }
    }
    
}
