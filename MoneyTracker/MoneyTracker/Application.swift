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
    
    func presentationAccounts(_ presentation: Presentation) -> [Account] {
        let account1 = Account(id: "1", name: "name1", balance: Decimal(1), currency: .sgd, backgroundColor: .green)
        let account2 = Account(id: "2", name: "name2", balance: Decimal(2), currency: .usd, backgroundColor: .blue)
        let accounts = [account1, account2]
        return accounts
    }
    
    func presentationAccountBackgroundColors(_ presentation: Presentation) -> [UIColor] {
        let backgroundColors: [UIColor] = [.red, .green, .yellow, .blue, .brown, .cyan]
        return backgroundColors
    }
    
    func presentation(_ presentation: Presentation, addAccount addingAccount: AddingAccount) {
        print(addingAccount)
    }
    
    func presentation(_ presentation: Presentation, deleteAccount category: Account) {
        
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
