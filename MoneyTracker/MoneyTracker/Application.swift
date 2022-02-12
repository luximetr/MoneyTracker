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

class Application: AUIEmptyApplication, PresentationDelegate {
    
    // MARK: Events
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        presentation.display()
        
//        saveAccount(getUOBBalanceAccount())
//        saveAccount(getDBSBalanceAccount())
//
//        saveCategory(getTransportCategory())
//        saveCategory(getGroceriesCategory())
//        saveCategory(getHouseCategory())
        
//        saveExpense(amount: 1.50, comment: nil, date: create2022Date(month: 1, day: 5), account: getUOBBalanceAccount(), category: getGroceriesCategory())
//        saveExpense(amount: 2.35, comment: "Bananas", date: create2022Date(month: 1, day: 23), account: getUOBBalanceAccount(), category: getGroceriesCategory())
//        saveExpense(amount: 5.24, comment: "Apples", date: create2022Date(month: 1, day: 15), account: getUOBBalanceAccount(), category: getGroceriesCategory())
//        saveExpense(amount: 2.11, comment: "Bus from home", date: create2022Date(month: 2, day: 1), account: getDBSBalanceAccount(), category: getTransportCategory())
//        saveExpense(amount: 50.00, comment: "Internet", date: create2022Date(month: 2, day: 9), account: getDBSBalanceAccount(), category: getHouseCategory())
//        saveExpense(amount: 2000, comment: "Rental for January", date: create2022Date(month: 2, day: 2), account: getDBSBalanceAccount(), category: getHouseCategory())
        
//        let dbsExpenses = (try? storage.getExpenses(balanceAccountId: getDBSBalanceAccount().id)) ?? []
//        let uobExpenses = (try? storage.getExpenses(balanceAccountId: getUOBBalanceAccount().id)) ?? []
//        let groceriesExpenses = (try? storage.getExpenses(categoryId: getGroceriesCategory().id)) ?? []
//        let transportExpenses = (try? storage.getExpenses(categoryId: getTransportCategory().id)) ?? []
//        let houseExpenses = (try? storage.getExpenses(categoryId: getHouseCategory().id)) ?? []
//        let allTimeExpenses = (try? storage.getExpenses(startDate: create2022Date(month: 1, day: 5), endDate: create2022Date(month: 2, day: 9))) ?? []
//        let januaryExpenses = (try? storage.getExpenses(startDate: create2022Date(month: 1, day: 1), endDate: create2022Date(month: 1, day: 31))) ?? []
//        let fabruaryExpenses = (try? storage.getExpenses(startDate: create2022Date(month: 2, day: 1), endDate: create2022Date(month: 2, day: 28))) ?? []
//
//        print("dbs expense comment: \(dbsExpenses.map { $0.comment ?? "" })")
//        print("uob expense comment: \(uobExpenses.map { $0.comment ?? "" })")
//        print("groceries expense comment: \(groceriesExpenses.map { $0.comment ?? "" })")
//        print("transport expense comment: \(transportExpenses.map { $0.comment ?? "" })")
//        print("house expense comment: \(houseExpenses.map { $0.comment ?? "" })")
//        print("all time expenses comment: \(allTimeExpenses.map( { $0.comment ?? "" }))")
//        print("january expenses comment: \(januaryExpenses.map( { $0.comment ?? "" }))")
//        print("fabruary expenses comment: \(fabruaryExpenses.map( { $0.comment ?? "" }))")
        
//        print(try? storage.getAllExpenses())
//        print(try? storage.getExpenses(categoryId: category.id))
        
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
            return BalanceAccount(id: "mockUOBId", name: name, currency: .sgd)
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
    
    private func getTransportCategory() -> StorageCategory {
        return findCategory(name: "Transport")
    }
    
    private func getGroceriesCategory() -> StorageCategory {
        return findCategory(name: "Groceries")
    }
    
    private func getHouseCategory() -> StorageCategory {
        return findCategory(name: "House")
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
        try? storage.addBalanceAccount(AddingBalanceAccount(name: account.name, currency: account.currency))
    }
    
    private func saveExpense(amount: Decimal, comment: String? = nil, date: Date, account: BalanceAccount, category: StorageCategory) {
        let addingExpense = AddingExpense(
            amount: amount,
            date: date,
            comment: comment,
            balanceAccountId: account.id,
            categoryId: category.id
        )
        try? storage.addExpense(addingExpense: addingExpense)
    }
    
    private func create2022Date(month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
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
        do {
            let storageCategories = try storage.getOrderedCategories()
            let categories = storageCategories.map({ Category(storageCategoty: $0) })
            let presentationCategories = categories.map({ $0.presentationCategory })
            return presentationCategories
        } catch {
            print(error)
            return []
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
    
    func presentation(_ presentation: Presentation, editCategory editingCategory: PresentationCategory) {
        do {
            let storageCategory = Category(presentationCategory: editingCategory).storageCategoty
            try storage.updateCategory(id: storageCategory.id, newValue: storageCategory)
        } catch {
            print(error)
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
    
}
