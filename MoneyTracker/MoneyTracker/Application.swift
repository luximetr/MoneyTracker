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
import MoneyTrackerNetwork
import Fawazahmed0CurrencyApi

typealias Presentation = MoneyTrackerPresentation.Presentation
typealias PresentationDelegate = MoneyTrackerPresentation.PresentationDelegate
typealias Storage = MoneyTrackerStorage.Storage
typealias Files = MoneyTrackerFiles.Files
typealias Network = MoneyTrackerNetwork.Network

class Application: AUIEmptyApplication, PresentationDelegate {
    
    // MARK: - Data
    
    private var calendar: Calendar!
    
    private var storage: Storage!
    
    private var language: Language!
    
    private var basicCurrency: Currency!
    
    private var network: Network!
    
    private var presentation: Presentation!
    
    private var files: Files!
    
    private var totalAmountViewSetting: TotalAmountViewSetting!
    
    // MARK: - Initialization
    
    private func initialize() throws {
        do {
            self.initializeCalendar()
            try self.initializeStorage()
            try self.initializeLanguage()
            try self.initializeBasicCurrency()
            self.initializeNetwork()
            try self.initializePresentation()
            self.initializeFiles()
            try self.initializeTotalAmountViewSetting()
        } catch {
            throw Error("Cannot initialize \(String(reflecting: Self.self))")
        }
    }
    
    private func initializeCalendar() {
        let calendar = Calendar.current
        self.calendar = calendar
    }
    
    private func initializeStorage() throws {
        do {
            let storage = try Storage()
            self.storage = storage
        } catch {
            throw Error("Cannot initialize \(String(reflecting: Storage.self))")
        }
    }
    
    private func initializeLanguage() throws {
        do {
            let language: Language
            if let storageLanguage = try storage.getSelectedLanguage() {
                language = LanguageMapper.mapToLanguage(storageLanguage)
            } else {
                let defaultLanguage: Language = .english
                language = defaultLanguage
            }
            self.language = language
        } catch {
            throw Error("Cannot initialize language\n\(error)")
        }
    }
    
    private func initializeBasicCurrency() throws {
        do {
            if let storageBasicCurrency = try storage.getBasicCurrency() {
                self.basicCurrency = CurrencyMapper.mapToCurrency(storageBasicCurrency)
            } else {
                let defaultBasicCurrency: Currency = .singaporeDollar
                self.basicCurrency = defaultBasicCurrency
            }
        } catch {
            throw Error("Cannot initialize basicCurrency\n\(error)")
        }
    }
    
    private func initializeNetwork() {
        let network = Network()
        self.network = network
    }
    
    private lazy var presentationWindow: UIWindow = {
        let window = createPresentationWindow()
        self.window = window
        window.makeKeyAndVisible()
        return window
    }()
    
    private func createPresentationWindow() -> UIWindow {
        let window = TraitCollectionChangeNotifyWindow()
        window.didChangeUserInterfaceStyleClosure = { [weak self] style in
            self?.presentation.didChangeUserInterfaceStyle(style)
        }
        return window
    }
    
    private func initializePresentation() throws {
        do {
            let appearanceSetting: AppearanceSetting
            if let storageAppearanceSetting = try storage.getSelectedAppearanceSetting() {
                appearanceSetting = AppearanceSettingMapper.mapToAppearanceSetting(storageAppearanceSetting)
            } else {
                let defaultAppearanceSetting: AppearanceSetting = .system
                appearanceSetting = defaultAppearanceSetting
            }
            let presentationAppearanceSetting = AppearanceSettingMapper.mapToPresentationAppearanceSetting(appearanceSetting)
            let presentationLanguage = LanguageMapper.mapToPresentationLanguage(language)
            let foundationLocaleCurrent = Locale.current
            let foundationLocaleCurrentScriptCode = foundationLocaleCurrent.scriptCode
            let foundationLocaleCurrentRegionCode = foundationLocaleCurrent.regionCode
            let presentationLocale = Locale(language: presentationLanguage, scriptCode: foundationLocaleCurrentScriptCode, regionCode: foundationLocaleCurrentRegionCode)
            let presentation = Presentation(window: presentationWindow, appearanceSetting: presentationAppearanceSetting, locale: presentationLocale, calendar: calendar)
            presentation.delegate = self
            self.presentation = presentation
        } catch {
            throw Error("Cannot initialize \(String(reflecting: Presentation.self))")
        }
    }
    
    private func initializeFiles() {
        let files = Files()
        self.files = files
    }
    
    private func initializeTotalAmountViewSetting() throws {
        do {
            let totalAmountViewSetting: TotalAmountViewSetting
            if let storageTotalAmountViewSetting = try self.storage.getTotalAmountViewSetting() {
                totalAmountViewSetting = TotalAmountViewSettingMapper.mapToTotalAmountViewSetting(storageTotalAmountViewSetting)
            } else {
                let defaultTotalAmountViewSetting: TotalAmountViewSetting = .basicCurrency
                totalAmountViewSetting = defaultTotalAmountViewSetting
            }
            self.totalAmountViewSetting = totalAmountViewSetting
        } catch {
            throw Error("Cannot initialize totalAmountViewSetting\n\(error)")
        }
    }
    
    // MARK: - Events
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        do {
            try self.initialize()
            self.presentation.display()
        } catch {
            self.showError(error)
        }
    }
    
    // MARK: - Categories
    
    func presentationCategories(_ presentation: Presentation) throws -> [PresentationCategory] {
        do {
            let storageCategories = try storage.getCategoriesOrdered()
            let presentationCategories = storageCategories.map { CategoryAdapter().adaptToPresentation(storageCategory: $0) }
            return presentationCategories
        } catch {
            throw Error("Cannot get categories\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, addCategory addingCategory: PresentationAddingCategory) throws -> PresentationCategory {
        do {
            let storageAddingCategory = AddingCategoryAdapter().adaptToStorage(presentationAddingCategory: addingCategory)
            let storageAddedCategory = try storage.addCategory(storageAddingCategory)
            let presentationAddedCategory = CategoryAdapter().adaptToPresentation(storageCategory: storageAddedCategory)
            return presentationAddedCategory
        } catch {
            throw Error("Cannot add category \(addingCategory)\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, deleteCategory category: PresentationCategory) throws {
        do {
            let storageCategory = CategoryAdapter().adaptToStorage(presentationCategory: category)
            try storage.removeCategory(id: storageCategory.id)
        } catch {
            throw Error("Cannot delete category \(category)\n\(error)")
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
            throw Error("Cannot edit category \(presentationEditingCategory)\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, orderCategories presentationCategories: [PresentationCategory]) throws {
        do {
            let categoryAdapter = CategoryAdapter()
            let storageCategories = presentationCategories.map({ categoryAdapter.adaptToStorage(presentationCategory: $0) })
            try storage.saveCategoriesOrder(orderedIds: storageCategories.map({ $0.id }))
        } catch {
            throw Error("Cannot order categories \(presentationCategories)\n\(error)")
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
            throw Error("Cannot get accounts\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, addAccount addingAccount: PresentationAddingBalanceAccount) throws -> PresentationBalanceAccount {
        do {
            let storageAddingAccount = AddingBalanceAccountAdapter().adaptToStorage(presentationAddingAccount: addingAccount)
            let addedStorageAccount = try storage.addBalanceAccount(storageAddingAccount)
            let addedPresentationAccount = BalanceAccountAdapter().adaptToPresentation(storageAccount: addedStorageAccount)
            return addedPresentationAccount
        } catch {
            throw Error("Cannot add account \(addingAccount)\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, deleteAccount deletingAccount: PresentationBalanceAccount) throws {
        do {
            try storage.removeBalanceAccount(id: deletingAccount.id)
        } catch {
            throw Error("Cannot delete account \(deletingAccount)\n\(error)")
        }
    }

    func presentation(_ presentation: Presentation, orderAccounts presentationBalanceAccounts: [PresentationBalanceAccount]) throws {
        do {
            let balanceAccountAdapter = BalanceAccountAdapter()
            let storageCategories = presentationBalanceAccounts.map({ balanceAccountAdapter.adaptToStorage(presentationAccount: $0) })
            try storage.saveBalanceAccountOrder(orderedIds: storageCategories.map({ $0.id }))
        } catch {
            throw Error("Cannot order accounts \(presentationBalanceAccounts)\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, editAccount editingAccount: PresentationEditingBalanceAccount) throws -> PresentationBalanceAccount {
        do {
            let storageEditingAccount = EditingBalanceAccountAdapter().adaptToStorage(presentationEditingAccount: editingAccount)
            let editedStorageAccount = try storage.updateBalanceAccount(editingBalanceAccount: storageEditingAccount)
            let editedPresentationAccount = BalanceAccountAdapter().adaptToPresentation(storageAccount: editedStorageAccount)
            return editedPresentationAccount
        } catch {
            throw Error("Cannot edit account \(editingAccount)\n\(error)")
        }
    }
    
    // MARK: - Currencies
    
    func presentationCurrencies(_ presentation: Presentation) -> [PresentationCurrency] {
        return [.singaporeDollar, .usDollar, .hryvnia, .turkishLira, .baht, .euro]
    }
    
    // MARK: - Selected currency
    
    private var selectedCurrency: StorageCurrency?
    
    func presentationSelectedCurrency(_ presentation: Presentation) throws -> PresentationCurrency {
        let presentationBasicCurrency = CurrencyMapper.mapToPresentationCurrency(basicCurrency)
        return presentationBasicCurrency
    }
    
    func presentation(_ presentation: Presentation, updateSelectedCurrency presentationBasicCurrency: PresentationCurrency) {
        let basicCurrency = CurrencyMapper.mapToCurrency(presentationBasicCurrency)
        let storageBasicCurrency = CurrencyMapper.mapToStorageCurrency(basicCurrency)
        storage.saveBasicCurrency(storageBasicCurrency)
        self.basicCurrency = basicCurrency
    }
    
    // MARK: - Expenses
    
    func presentationDayCurrenciesAmount(_ presentation: Presentation, expense: [PresentationExpense], completionHandler: @escaping (Result<PresentationCurrenciesAmount?, Swift.Error>) -> Void) {
        if expense.isEmpty {
            completionHandler(.success(nil))
            return
        }
        let fawazahmed0CurrencyApiBasicCurrency = CurrencyMapper.mapToFawazahmed0CurrencyApiVersionaCurrency(basicCurrency)
        self.network.latestCurrenciesCurrency(fawazahmed0CurrencyApiBasicCurrency) { [weak self] result in
            guard let self = self else { return }
            let exchangeRates: ExchangeRates?
            switch result {
            case .success(let response):
                switch response {
                case .parsedResponse(let parsedResponse):
                    let fawazahmed0CurrencyApiExchangeRates = parsedResponse.exchangeRates
                    exchangeRates = ExchangeRatesMapper.mapToExchangeRates(fawazahmed0CurrencyApiExchangeRates)
                case .networkConnectionLost:
                    exchangeRates = nil
                case .notConnectedToInternet:
                    exchangeRates = nil
                }
            case .failure:
                exchangeRates = nil
            }
            let currenciesExpenses = Dictionary(grouping: expense) { $0.account.currency }
            let currenciesExpense = currenciesExpenses.mapValues({ $0.reduce(Decimal(), { $0 + $1.amount }) }).sorted(by: { $0.1 > $1.1 })
            let currencyAmounts = currenciesExpense.map({ CurrencyAmount(currency: CurrencyMapper.mapToCurrency($0.key), amount: $0.value) })
            var currenciesAmounts = CurrenciesAmount(currenciesAmount: Set(currencyAmounts))
            let storageTotalAmountViewSetting = (try? self.storage.getTotalAmountViewSetting()) ?? .basicCurrency
            let totalAmountViewSetting = TotalAmountViewSettingMapper.mapToTotalAmountViewSetting(storageTotalAmountViewSetting)
            if let exchangeRates = exchangeRates, totalAmountViewSetting == .basicCurrency {
                currenciesAmounts = self.calculateCurrenciesAmount(currenciesAmounts, basicCurrency: self.basicCurrency, exchangeRates: exchangeRates)
            }
            let presentationCurrenciesAmount = CurrenciesAmountMapper.mapToPresentationCurrenciesAmount(currenciesAmounts)
            completionHandler(.success(presentationCurrenciesAmount))
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
            throw Error("Cannot expenses months\n\(error)")
        }
    }
    
    private func calculateCurrenciesAmount(_ currenciesAmount: CurrenciesAmount, basicCurrency: Currency, exchangeRates: ExchangeRates) -> CurrenciesAmount {
        var basicAmount: Decimal = 0
        for currencyAmount in currenciesAmount {
            let currency = currencyAmount.currency
            let exchangeRate = exchangeRates[currency]
            let amount = currencyAmount.amount
            let basicCurrencyExchangeRateAmount = amount / exchangeRate
            basicAmount += basicCurrencyExchangeRateAmount
        }
        let basicCurrencyAmount = CurrencyAmount(currency: basicCurrency, amount: basicAmount)
        let basicCurrenciesAmount = CurrenciesAmount(currenciesAmount: [basicCurrencyAmount])
        return basicCurrenciesAmount
    }
    
    func presentationMonthExpenses(_ presentation: Presentation, month: Date, completionHandler: @escaping (Result<CategoriesMonthExpenses, Swift.Error>) -> Void) {
        do {
            let storageTotalAmountViewSetting = try storage.getTotalAmountViewSetting() ?? .basicCurrency
            let totalAmountViewSetting = TotalAmountViewSettingMapper.mapToTotalAmountViewSetting(storageTotalAmountViewSetting)
            func ddd(exchangeRates: ApiVersion1ExchangeRates?) {
                do {
                    let startDate = month.startOfMonth
                    let endDate = month.endOfMonth
                    let storageExpenses = try storage.getExpenses(startDate: startDate, endDate: endDate)
                    let expenseAdapter = ExpenseAdapter(storage: storage)
                    let presentationExpenses: [PresentationExpense] = try storageExpenses.map { storageExpense in
                        let presentationExpense = try expenseAdapter.adaptToPresentation(storageExpense: storageExpense)
                        return presentationExpense
                    }
                    let categoriesExpenses = Dictionary(grouping: presentationExpenses) { $0.category }
                    var categoriesMonthExpenses: [CategoryMonthExpenses] = []
                    var allCurrenciesAmounts: [PresentationCurrency: Decimal] = [:]
                    for (category, expenses) in categoriesExpenses {
                        var currenciesMoneyAmount: [PresentationCurrencyAmount] = []
                        var currenciesAmounts: [PresentationCurrency: Decimal] = [:]
                        for expense in expenses {
                            if let exchangeRates = exchangeRates {
                                let currency = expense.account.currency
                                let currency2 = CurrencyMapper.mapToFawazahmed0CurrencyApiVersionaCurrency(currency)
                                let presentationBasicCurrency = CurrencyMapper.mapToPresentationCurrency(basicCurrency)
                                let exchangeRate = exchangeRates[currency2]
                                let amount = expense.amount / exchangeRate
                                let currencyAmount = (currenciesAmounts[presentationBasicCurrency] ?? .zero) + amount
                                currenciesAmounts[presentationBasicCurrency] = currencyAmount
                                allCurrenciesAmounts[presentationBasicCurrency] = (allCurrenciesAmounts[presentationBasicCurrency] ?? Decimal()) + amount
                            } else {
                                let currency = expense.account.currency
                                let amount = expense.amount
                                let currencyAmount = (currenciesAmounts[currency] ?? .zero) + amount
                                currenciesAmounts[currency] = currencyAmount
                                allCurrenciesAmounts[currency] = (allCurrenciesAmounts[currency] ?? Decimal()) + amount
                            }
                        }
                        
                        for (key, value) in currenciesAmounts {
                            let currencyMoneyAmount = PresentationCurrencyAmount(amount: value, currency: key)
                            currenciesMoneyAmount.append(currencyMoneyAmount)
                        }
                        let moneyAmount = PresentationCurrenciesAmount(currenciesMoneyAmount: currenciesMoneyAmount)
                        let categoryMonthExpenses = CategoryMonthExpenses(category: category, expenses: moneyAmount)
                        categoriesMonthExpenses.append(categoryMonthExpenses)
                    }
                    let rr = allCurrenciesAmounts.map({ PresentationCurrencyAmount(amount: $1, currency: $0) })
                    let bv = PresentationCurrenciesAmount(currenciesMoneyAmount: rr)
                    let cme = CategoriesMonthExpenses(expenses: bv, categoriesMonthExpenses: categoriesMonthExpenses)
                    completionHandler(.success(cme))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            switch totalAmountViewSetting {
            case .basicCurrency:
                let presentationBasicCurrency = CurrencyMapper.mapToPresentationCurrency(basicCurrency)
                let gg = CurrencyMapper.mapToFawazahmed0CurrencyApiVersionaCurrency(presentationBasicCurrency)
                self.network.latestCurrenciesCurrency(gg) { result in
                    switch result {
                    case .success(let response):
                        switch response {
                        case .parsedResponse(let parsedResponse):
                            let exchangeRates = parsedResponse.exchangeRates
                            ddd(exchangeRates: exchangeRates)
                        case .networkConnectionLost:
                            ddd(exchangeRates: nil)
                        case .notConnectedToInternet:
                            ddd(exchangeRates: nil)
                        }
                    case .failure:
                        ddd(exchangeRates: nil)
                    }
                }
            case .originalCurrencies:
                ddd(exchangeRates: nil)
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func presentationBalance(_ presentation: Presentation, accounts: [PresentationBalanceAccount], completionHandler: @escaping (Result<PresentationCurrenciesAmount, Swift.Error>) -> Void) {
        do {
            let storageTotalAmountViewSetting = try storage.getTotalAmountViewSetting() ?? .basicCurrency
            let totalAmountViewSetting = TotalAmountViewSettingMapper.mapToTotalAmountViewSetting(storageTotalAmountViewSetting)
            func ddd(exchangeRates: ApiVersion1ExchangeRates?) {
                var currenciesAmounts: [PresentationCurrency: Decimal] = [:]
                for account in accounts {
                    let currency = account.currency
                    let amount = account.amount
                    if let exchangeRates = exchangeRates {
                        let currency2 = CurrencyMapper.mapToFawazahmed0CurrencyApiVersionaCurrency(currency)
                        let presentationBasicCurrency = CurrencyMapper.mapToPresentationCurrency(basicCurrency)
                        let exchangeRate = exchangeRates[currency2]
                        let amount = amount / exchangeRate
                        let currencyAmount = (currenciesAmounts[presentationBasicCurrency] ?? .zero) + amount
                        currenciesAmounts[presentationBasicCurrency] = currencyAmount
                    } else {
                        let currencyAmount = (currenciesAmounts[currency] ?? .zero) + amount
                        currenciesAmounts[currency] = currencyAmount
                    }
                }
                let rr = currenciesAmounts.map({ PresentationCurrencyAmount(amount: $1, currency: $0) })
                let bv = PresentationCurrenciesAmount(currenciesMoneyAmount: rr)
                completionHandler(.success(bv))
            }
            switch totalAmountViewSetting {
            case .basicCurrency:
                let presentationBasicCurrency = CurrencyMapper.mapToPresentationCurrency(basicCurrency)
                let fawazahmed0CurrencyApiVersionaBasicCurrency = CurrencyMapper.mapToFawazahmed0CurrencyApiVersionaCurrency(presentationBasicCurrency)
                self.network.latestCurrenciesCurrency(fawazahmed0CurrencyApiVersionaBasicCurrency) { result in
                    switch result {
                    case .success(let response):
                        switch response {
                        case .parsedResponse(let parsedResponse):
                            let exchangeRates = parsedResponse.exchangeRates
                            ddd(exchangeRates: exchangeRates)
                        case .networkConnectionLost:
                            ddd(exchangeRates: nil)
                        case .notConnectedToInternet:
                            ddd(exchangeRates: nil)
                        }
                    case .failure:
                        ddd(exchangeRates: nil)
                    }
                }
            case .originalCurrencies:
                ddd(exchangeRates: nil)
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func presentationExpenses(_ presentation: Presentation) throws -> [PresentationExpense] {
        do {
            let expenses = try storage.getAllExpenses()
            let presentationExpenses: [PresentationExpense] = try expenses.map { expense in
                return try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: expense)
            }
            return presentationExpenses.reversed()
        } catch {
            throw Error("Cannot get expenses\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, addExpense presentationAddingExpense: PresentationAddingExpense) throws -> PresentationExpense {
        do {
            let storageAddingExpense = AddingExpenseAdapter(storage: storage).adaptToStorage(presentationAddingExpense: presentationAddingExpense)
            let storageAddedExpense = try storage.addExpense(addingExpense: storageAddingExpense)
            let presentationExpense = try ExpenseAdapter(storage: storage).adaptToPresentation(storageExpense: storageAddedExpense)
            return presentationExpense
        } catch {
            throw Error("Cannot add expense \(presentationAddingExpense)\n\(error)")
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
            throw Error("Cannot edit expense \(editingExpense)\n\(error)")
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
            throw Error("Cannot get expense templates\n\(error)")
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
            throw Error("Cannot add expense template \(addingExpenseTemplate)\n\(error)")
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
            throw Error("Cannot add expense template \(editingExpenseTemplate)\n\(error)")
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
            throw Error("Cannot reorder expense templates\n\(error)")
        }
    }
    
    func presentation(_ presentation: Presentation, deleteExpenseTemplate expenseTemplate: PresentationExpenseTemplate) throws {
        do {
            try storage.removeExpenseTemplate(expenseTemplateId: expenseTemplate.id)
        } catch {
            throw Error("Cannot delete expense template \(expenseTemplate)\n\(error)")
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
        let categoriesAdapter = ExportingCategoryAdapter()
        let storageCategories = try storage.getCategoriesOrdered()
        let filesCategories = storageCategories.map { categoriesAdapter.adaptToFiles(storageCategory: $0) }
        let balanceAccountsAdapter = ExportingBalanceAccountAdapter()
        let storageBalanceAccounts = try storage.getAllBalanceAccountsOrdered()
        let filesBalanceAccounts = storageBalanceAccounts.map { balanceAccountsAdapter.adaptToFiles(storageAccount: $0) }
        
        let operations = try storage.getOperations()
        let operationAdapter = ExportingOperationAdapter()
        let filesOperations = operations.map { operationAdapter.adaptToFiles(storageOperation: $0) }
        
        let exportFile = ExportExpensesFile(
            balanceAccounts: filesBalanceAccounts,
            categories: filesCategories,
            operations: filesOperations
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
            throw Error("Cannot add presentation transfer \(presentationAddingTransfer)\n\(error)")
        }
    }
    
    // MARK: - Top Up Account
    
    func presentation(_ presentation: Presentation, addReplenishment presentationAddingReplenishment: PresentationAddingReplenishment) throws -> PresentationReplenishment {
        do {
            let timestamp = presentationAddingReplenishment.timestamp
            let balanceAccountId = presentationAddingReplenishment.account.id
            let amount = Int64(try (presentationAddingReplenishment.amount * 100).int())
            let comment = presentationAddingReplenishment.comment
            let storageAddingBalanceReplenishment = AddingReplenishment(timestamp: timestamp, accountId: balanceAccountId, amount: amount, comment: comment)
            let storageBalanceTransfer = try storage.addBalanceReplenishment(storageAddingBalanceReplenishment)
            let presentationReplenishment = PresentationReplenishment(id: storageBalanceTransfer.id, timestamp: presentationAddingReplenishment.timestamp, account: presentationAddingReplenishment.account, amount: presentationAddingReplenishment.amount, comment: presentationAddingReplenishment.comment)
            return presentationReplenishment
        } catch {
            throw Error("Cannot add presentation top up account \(presentationAddingReplenishment)\n\(error)")
        }
    }
    
    // MARK: - Operations
    
    func presentationLoadHistoryItems(_ presentation: Presentation, completionHandler: (@escaping (Result<[Historyitem]?, Swift.Error>) -> Void)) {
        let fawazahmed0CurrencyApiBasicCurrency = CurrencyMapper.mapToFawazahmed0CurrencyApiVersionaCurrency(basicCurrency)
        self.network.latestCurrenciesCurrency(fawazahmed0CurrencyApiBasicCurrency) { [weak self] result in
            guard let self = self else { return }
            let exchangeRates: ExchangeRates?
            switch result {
            case .success(let response):
                switch response {
                case .parsedResponse(let parsedResponse):
                    let fawazahmed0CurrencyApiExchangeRates = parsedResponse.exchangeRates
                    exchangeRates = ExchangeRatesMapper.mapToExchangeRates(fawazahmed0CurrencyApiExchangeRates)
                case .networkConnectionLost:
                    exchangeRates = nil
                case .notConnectedToInternet:
                    exchangeRates = nil
                }
            case .failure:
                exchangeRates = nil
            }
            do {
                let storageOperations = try self.storage.getOperations()
                let operationAdapter = OperationAdapter(storage: self.storage)
                let presentationOperations = storageOperations.map { operationAdapter.adaptToPresentation(storageOperation: $0) }
                
                var historyItems: [Historyitem] = []
                let daysPresentationExpenses = Dictionary(grouping: presentationOperations) { self.calendar.startOfDay(for: $0.timestamp) }.sorted(by: { $0.0 > $1.0 })
                for (day, presentationExpenses) in daysPresentationExpenses {
                    let expenses: [PresentationExpense] = presentationExpenses.compactMap { operation in
                        if case let .expense(expense) = operation { return expense }
                        else { return nil }
                    }
                    let currenciesExpenses = Dictionary(grouping: expenses) { $0.account.currency }
                    let currenciesExpense = currenciesExpenses.mapValues({ $0.reduce(Decimal(), { $0 + $1.amount }) }).sorted(by: { $0.1 > $1.1 })
                    let currencyAmounts = currenciesExpense.map({ CurrencyAmount(currency: CurrencyMapper.mapToCurrency($0.key), amount: $0.value) })
                    var currenciesAmounts = CurrenciesAmount(currenciesAmount: Set(currencyAmounts))
                    if let exchangeRates = exchangeRates, self.totalAmountViewSetting == .basicCurrency {
                        currenciesAmounts = self.calculateCurrenciesAmount(currenciesAmounts, basicCurrency: self.basicCurrency, exchangeRates: exchangeRates)
                    }
                    let presentationCurrenciesAmount = CurrenciesAmountMapper.mapToPresentationCurrenciesAmount(currenciesAmounts)
                    let dayHistoryItem: Historyitem = .day(day, presentationCurrenciesAmount)
                    historyItems.append(dayHistoryItem)
                    for presentationOperation in presentationExpenses {
                        switch presentationOperation {
                        case .expense(let expense):
                            let expenseHistoryItem: Historyitem = .expense(expense)
                            historyItems.append(expenseHistoryItem)
                        case .transfer(let transfer):
                            let transferHistoryItem: Historyitem = .transfer(transfer)
                            historyItems.append(transferHistoryItem)
                        case .replenishment(let replenishment):
                            let replenishmentHistoryItem: Historyitem = .replenishment(replenishment)
                            historyItems.append(replenishmentHistoryItem)
                        }
                    }
                }
                
                completionHandler(.success(historyItems))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: - Language
    
    func presentationLanguages(_ presentation: Presentation) throws -> [PresentationLanguage] {
        let languages: [Language] = [.english, .ukrainian, .thai]
        let presentationLanguages = languages.map({ LanguageMapper.mapToPresentationLanguage($0) })
        return presentationLanguages
    }
    
    func presentation(_ presentation: Presentation, selectLanguage presentationLanguage: PresentationLanguage) throws {
        let language = LanguageMapper.mapToLanguage(presentationLanguage)
        let storageLanguage = LanguageMapper.mapToStorageLanguage(language)
        storage.saveSelectedLanguage(storageLanguage)
    }
    
    // MARK: - Appearance
    
    func presentation(_ presentation: Presentation, selectAppearanceSetting presentationAppearanceSetting: PresentationAppearanceSetting) throws {
        let appearanceSetting = AppearanceSettingMapper.mapToAppearanceSetting(presentationAppearanceSetting)
        let storageAppearanceSetting = AppearanceSettingMapper.mapToStorageAppearanceSetting(appearanceSetting)
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
    
    func presentation(_ presentation: Presentation, editReplenishment presentationEditingReplenishment: PresentationEditingReplenishment) throws -> PresentationReplenishment {
        do {
            let storageEditingReplenishment = StorageEditingReplenishment(id: presentationEditingReplenishment.id, timestamp: presentationEditingReplenishment.timestamp, accountId: presentationEditingReplenishment.account.id, amount: presentationEditingReplenishment.amount, comment: presentationEditingReplenishment.comment)
            try storage.editReplenishment(storageEditingReplenishment)
            return PresentationReplenishment(id: presentationEditingReplenishment.id, timestamp: presentationEditingReplenishment.timestamp, account: presentationEditingReplenishment.account, amount: presentationEditingReplenishment.amount, comment: presentationEditingReplenishment.comment)
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
    
    func presentation(_ presentation: Presentation, selectTotalAmountViewSetting presentationTotalAmountViewSetting: PresentationTotalAmountViewSetting) throws {
        let totalAmountViewSetting = TotalAmountViewSettingMapper.mapToTotalAmountViewSetting(presentationTotalAmountViewSetting)
        let storageTotalAmountViewSetting = TotalAmountViewSettingMapper.mapToStorageTotalAmountViewSetting(totalAmountViewSetting)
        storage.saveTotalAmountViewSetting(storageTotalAmountViewSetting)
    }
    
    func presentationTotalAmountViewSetting(_ presentation: Presentation) throws -> PresentationTotalAmountViewSetting {
        do {
            let storageTotalAmountViewSetting = try storage.getTotalAmountViewSetting() ?? .basicCurrency
            let totalAmountViewSetting = TotalAmountViewSettingMapper.mapToTotalAmountViewSetting(storageTotalAmountViewSetting)
            let presentationTotalAmountViewSetting = TotalAmountViewSettingMapper.mapToPresentationTotalAmountViewSetting(totalAmountViewSetting)
            return presentationTotalAmountViewSetting
        } catch {
            throw Error("Cannot determine presentation TotalAmountViewSetting\n\(error)")
        }
    }
    
    // MARK: Error
    
    private func showError(_ error: Swift.Error) {
        let window = self.window ?? UIWindow()
        let errorViewController = Presentation.createUnexpectedErrorViewController(error)
        window.rootViewController = errorViewController
        window.makeKeyAndVisible()
    }
    
}
