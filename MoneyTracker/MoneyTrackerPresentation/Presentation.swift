//
//  Presentation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit
import MessageUI

public protocol PresentationDelegate: AnyObject {
    func presentationCategories(_ presentation: Presentation) throws -> [Category]
    func presentation(_ presentation: Presentation, addCategory addingCategory: AddingCategory) throws -> Category
    func presentation(_ presentation: Presentation, editCategory editingCategory: Category) throws -> Category
    func presentation(_ presentation: Presentation, deleteCategory category: Category) throws
    func presentation(_ presentation: Presentation, orderCategories categories: [Category]) throws
    func presentationCurrencies(_ presentation: Presentation) -> [Currency]
    func presentationSelectedCurrency(_ presentation: Presentation) -> Currency
    func presentation(_ presentation: Presentation, updateSelectedCurrency currency: Currency)
    func presentationAccounts(_ presentation: Presentation) throws -> [Account]
    func presentation(_ presentation: Presentation, deleteAccount category: Account) throws
    func presentation(_ presentation: Presentation, addAccount addingAccount: AddingAccount) throws -> Account
    func presentation(_ presentation: Presentation, editAccount editingAccount: Account) throws -> Account
    func presentation(_ presentation: Presentation, orderAccounts accounts: [Account]) throws
    func presentationExpenseTemplates(_ presentation: Presentation) -> [ExpenseTemplate]
    func presentationExpenseTemplates(_ presentation: Presentation, limit: Int) -> [ExpenseTemplate]
    func presentation(_ presentation: Presentation, reorderExpenseTemplates reorderedExpenseTemplates: [ExpenseTemplate])
    func presentation(_ presentation: Presentation, deleteExpenseTemplate expenseTemplate: ExpenseTemplate)
    func presentation(_ presentation: Presentation, addExpenseTemplate addingExpenseTemplate: AddingExpenseTemplate) -> ExpenseTemplate
    func presentation(_ presentation: Presentation, editExpenseTemplate editingExpenseTemplate: EditingExpenseTemplate) -> ExpenseTemplate
    func presentation(_ presentation: Presentation, didPickDocumentAt url: URL)
    func presentationDidStartExpensesCSVExport(_ presentation: Presentation) throws -> URL
    func presentationDayExpenses(_ presentation: Presentation, day: Date) throws -> [Expense]
    func presentation(_ presentation: Presentation, addExpense addingExpense: AddingExpense) throws -> Expense
    func presentation(_ presentation: Presentation, editExpense editingExpense: Expense) throws -> Expense
    func presentation(_ presentation: Presentation, deleteExpense deletingExpense: Expense) throws -> Expense
    func presentationExpenses(_ presentation: Presentation) throws -> [Expense]
    func presentationMonthExpenses(_ presentation: Presentation, month: Date) throws -> [Expense]
    func presentationExpensesMonths(_ presentation: Presentation) -> [Date]
}

public final class Presentation: AUIWindowPresentation {
    
    // MARK: Delegate
    
    public weak var delegate: PresentationDelegate!
    
    // MARK: Display
    
    public func display() {
        // Dashboard
        let dashboardViewController = createDashboardViewController()
        let dashboardNavigationController = AUINavigationBarHiddenNavigationController()
        dashboardNavigationController.viewControllers = [dashboardViewController]
        self.dashboardViewController = dashboardViewController
        self.dashboardNavigationController = dashboardNavigationController
        // History
        let historyViewController = createHistoryViewController()
        let historyNavigationController = AUINavigationBarHiddenNavigationController()
        historyNavigationController.viewControllers = [historyViewController]
        self.historyViewController = historyViewController
        self.historyNavigationController = historyNavigationController
        // Statistic
        let statisticViewController = createStatisticScreen()
        let statisticNavigationController = AUINavigationBarHiddenNavigationController()
        statisticNavigationController.viewControllers = [statisticViewController]
        self.statisticScreen = statisticViewController
        // Settings
        let settingsViewController = createSettingsScreenViewController()
        let settingsNavigationController = AUINavigationBarHiddenNavigationController()
        settingsNavigationController.viewControllers = [settingsViewController]
        self.settingsScreenViewController = settingsViewController
        self.settingsNavigationController = settingsNavigationController
        // Menu
        let menuViewController = MenuScreenViewController(dashboardScreenViewController: dashboardNavigationController, historyScreenViewController: historyNavigationController, statisticScreenViewController: statisticNavigationController, settingsScreenViewController: settingsNavigationController)
        let menuNavigationController = AUINavigationBarHiddenNavigationController()
        menuNavigationController.viewControllers = [menuViewController]
        self.menuNavigationController = menuNavigationController
        self.menuScreenViewController = menuViewController
        window.rootViewController = menuNavigationController
        menuViewController.settings()
    }
    
    // MARK: Menu Navigation Controller
    
    private weak var menuNavigationController: UINavigationController?
    
    // MARK: Menu View Controller
    
    private weak var menuScreenViewController: MenuScreenViewController?
    
    // MARK: Dashboard Navigation Controller
    
    private weak var dashboardNavigationController: UINavigationController?
    
    // MARK: Dashboard View Controller
    
    private weak var dashboardViewController: DashboardScreenViewController?
    
    private func createDashboardViewController() -> DashboardScreenViewController {
        let categories = (try? delegate.presentationCategories(self)) ?? []
        let accounts = (try? delegate.presentationAccounts(self)) ?? []
        let templates = delegate.presentationExpenseTemplates(self, limit: 5)
        let viewController = DashboardScreenViewController(categories: categories, accounts: accounts, templates: templates)
        viewController.addExpenseClosure = { [weak self] category in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            self.pushAddExpenseViewController(menuNavigationController, selectedCategory: category)
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddCategoryScreenViewController(viewController)
        }
        viewController.transferClosure = {
            // TODO: Show transfer screen
            print("Show transfer screen")
        }
        viewController.topUpAccountClosure = { account in
            // TODO: Show top up account screen
            print("Show top up account screen \(account.id)")
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddAccountViewController(viewController)
        }
        viewController.addTemplateClosure = { [weak self] in
            guard let self = self else { return }
            self.presentAddTemplateScreenViewController(viewController)
        }
        viewController.useTemplateClosure = { [weak self] addingExpense in
            guard let self = self else { throw Error("") }
            do {
                let addedExpense = try self.delegate.presentation(self, addExpense: addingExpense)
                self.historyViewController?.insertExpense(addedExpense)
                self.statisticScreen?.addExpense(addedExpense)
                return addedExpense
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        viewController.displayExpenseAddedSnackbarClosure = { [weak self] addedExpense in
            guard let self = self else { return }
            self.displayExpenseAddedSnackbarViewController(expense: addedExpense)
        }
        return viewController
    }
    
    // MARK: ExpenseAddedSnackbarView
    
    private var expenseAddedSnackbarViewControllers: [ExpenseAddedSnackbarViewController] = []
    
    private func createExpenseAddedSnackbarViewController(expense: Expense) -> ExpenseAddedSnackbarViewController {
        let viewController = ExpenseAddedSnackbarViewController(expense: expense)
        let view = ExpenseAddedSnackbarView()
        viewController.expenseAddedSnackbarView = view
        return viewController
    }
    
    private func displayExpenseAddedSnackbarViewController(expense: Expense) {
        let viewController = createExpenseAddedSnackbarViewController(expense: expense)
        guard let view = viewController.view else{ return }
        expenseAddedSnackbarViewControllers.append(viewController)
        window.showSnackbarViewAnimated(view) { [weak self] _ in
            guard let self = self else { return }
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
                guard let self = self else { return }
                self.window.hideSnackbarViewAnimated(view) { _ in
                    timer.invalidate()
                }
            }
        }
    }
    
    // MARK: History Navigation Controller
    
    private weak var historyNavigationController: UINavigationController?
    
    // MARK: History View Controller
    
    private weak var historyViewController: HistoryScreenViewController?
    
    private func createHistoryViewController() -> HistoryScreenViewController {
        let expenses = (try? delegate.presentationExpenses(self)) ?? []
        let viewController = HistoryScreenViewController(expenses: expenses)
        viewController.deleteExpenseClosure = { [weak self] deletingExpense in
            guard let self = self else { return }
            do {
                let deletedExpense = try self.delegate.presentation(self, deleteExpense: deletingExpense)
                self.statisticScreen?.deleteExpense(deletedExpense)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.selectExpenseClosure = { [weak self] expense in
            guard let self = self else { return }
            let editExpenseViewController = self.createEditExpenseViewController(expense: expense)
            self.editExpenseViewController = editExpenseViewController
            self.menuNavigationController?.pushViewController(editExpenseViewController, animated: true)
        }
        historyViewController = viewController
        return viewController
    }
    
    // MARK: Edit Expense View Controller
    
    private weak var editExpenseViewController: EditExpenseScreenViewController?
    
    private func createEditExpenseViewController(expense: Expense) -> EditExpenseScreenViewController {
        let accounts = try! delegate.presentationAccounts(self)
        let categories = try! delegate.presentationCategories(self)
        let viewController = EditExpenseScreenViewController(expense: expense, categories: categories, balanceAccounts: accounts)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddAccountViewController(viewController)
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddCategoryScreenViewController(viewController)
        }
        viewController.editExpenseClosure = { [weak self] expense in
            guard let self = self else { return }
            do {
                let editedExpense = try self.delegate.presentation(self, editExpense: expense)
                self.historyViewController?.editExpense(editedExpense)
                self.statisticScreen?.editExpense(editedExpense)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: Add Expense View Controller
    
    private weak var pushedAddExpenseViewController: AddExpenseScreenViewController?
    
    private func pushAddExpenseViewController(_ navigationController: UINavigationController, selectedCategory: Category?) {
        let accounts = try! delegate.presentationAccounts(self)
        let categories = try! delegate.presentationCategories(self)
        let viewController = AddExpenseScreenViewController(accounts: accounts, categories: categories, selectedCategory: selectedCategory)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.dayExpensesClosure = { [weak self] day in
            guard let self = self else { return [] }
            do {
                let dayExpenses = try self.delegate.presentationDayExpenses(self, day: day)
                return dayExpenses
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                return []
            }
        }
        viewController.addExpenseClosure = { [weak self] addingExpense in
            guard let self = self else { throw Error("") }
            do {
                let addedExpense = try self.delegate.presentation(self, addExpense: addingExpense)
                self.historyViewController?.insertExpense(addedExpense)
                self.statisticScreen?.addExpense(addedExpense)
                return addedExpense
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        viewController.deleteExpenseClosure = { [weak self] expense in
            guard let self = self else { return }
            do {
                let deletedExpense = try self.delegate.presentation(self, deleteExpense: expense)
                self.historyViewController?.deleteExpense(deletedExpense)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddAccountViewController(viewController)
        }
        pushedAddExpenseViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: Settings Navigation Controller
    
    private weak var settingsNavigationController: UINavigationController?
    
    // MARK: Categories View Controller
    
    private weak var pushedCategoriesViewController: CategoriesScreenViewController?
    
    private func pushCategoriesViewController(_ navigationController: UINavigationController) throws {
        do {
            let categories: [Category] = try delegate.presentationCategories(self)
            let viewController = CategoriesScreenViewController(categories: categories)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.editCategoryClosure = { [weak self] category in
                guard let self = self else { return }
                guard let menuNavigationController = self.menuNavigationController else { return }
                self.pushEditCategoryScreenViewController(menuNavigationController, category: category)
            }
            viewController.deleteCategoryClosure = { [weak self] category in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, deleteCategory: category)
                    self.dashboardViewController?.deleteCategory(category)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                    throw error
                }
            }
            viewController.orderCategoriesClosure = { [weak self] categories in
                guard let self = self else { return }
                do {
                    self.dashboardViewController?.orderCategories(categories)
                    try self.delegate.presentation(self, orderCategories: categories)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                    throw error
                }
            }
            viewController.addCategoryClosure = { [weak self, weak navigationController] in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                self.pushAddCategoryScreenViewController(navigationController)
            }
            pushedCategoriesViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push CategoriesViewController\n\(error)")
            throw error
        }
        
    }
    
    // MARK: Add Category View Controller
    
    private var pushedAddCategoryViewController: AddCategoryScreenViewController?
    private func pushAddCategoryScreenViewController(_ navigationController: UINavigationController) {
        let viewController = AddCategoryScreenViewController()
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.addCategoryClosure = { [weak self, weak navigationController] addingCategory in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            do {
                let addedCategory = try self.delegate.presentation(self, addCategory: addingCategory)
                self.dashboardViewController?.addCategory(addedCategory)
                self.pushedCategoriesViewController?.addCategory(addedCategory)
                self.editExpenseViewController?.addCategory(addedCategory)
                self.pushedEditTemplateScreenViewController?.addCategory(addedCategory)
                self.pushedAddTemplateScreenViewController?.addCategory(addedCategory)
                navigationController.popViewController(animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.selectIconClosure = { [weak self] in
            guard let self = self else { return }
            let selectIconViewController = self.createSelectIconViewController()
            self.menuNavigationController?.present(selectIconViewController, animated: true)
        }
        self.pushedAddCategoryViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private var presentedAddCategoryViewController: AddCategoryScreenViewController?
    private func presentAddCategoryScreenViewController(_ presentingViewController: UIViewController) {
        let viewController = AddCategoryScreenViewController()
        viewController.backClosure = { [weak viewController] in
            guard let viewController = viewController else { return }
            viewController.dismiss(animated: true, completion: nil)
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] addingCategory in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            do {
                let addedCategory = try self.delegate.presentation(self, addCategory: addingCategory)
                self.dashboardViewController?.addCategory(addedCategory)
                self.pushedCategoriesViewController?.addCategory(addedCategory)
                self.editExpenseViewController?.addCategory(addedCategory)
                self.pushedEditTemplateScreenViewController?.addCategory(addedCategory)
                self.pushedAddTemplateScreenViewController?.addCategory(addedCategory)
                viewController.dismiss(animated: true, completion: nil)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        presentedAddCategoryViewController = viewController
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: Edit Category View Controller
    
    private weak var pushedEditCategoryViewController: EditCategoryScreenViewController?
    private func pushEditCategoryScreenViewController(_ navigationController: UINavigationController, category: Category) {
        let viewController = EditCategoryScreenViewController(category: category)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.editCategoryClosure = { [weak self, weak navigationController] category in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            do {
                let editedCategory = try self.delegate.presentation(self, editCategory: category)
                self.pushedCategoriesViewController?.editCategory(editedCategory)
                self.dashboardViewController?.editCategory(editedCategory)
                navigationController.popViewController(animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        pushedEditCategoryViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Select Icon View Controller
    
    private func createSelectIconViewController() -> SelectIconScreenViewController {
        let viewController = SelectIconScreenViewController(iconColor: Colors.greenCardSecondaryBackground)
//        viewController.didSelectIconClosure = {
//            
//        }
        return viewController
    }
    
    // MARK: - Settings Screen View Controller
    
    private weak var settingsScreenViewController: SettingsScreenViewController?
    
    private func createSettingsScreenViewController() -> SettingsScreenViewController {
        let viewController = SettingsScreenViewController()
        viewController.didSelectCategoriesClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushCategoriesViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.didSelectCurrencyClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createSelectCurrencyViewController()
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.didSelectAccountsClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushAccountsViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.didSelectTemplatesClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            self.pushTemplatesScreenViewController(menuNavigationController)
        }
        viewController.didSelectImportCSVClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createImportCSVScreen()
            self.menuNavigationController?.present(viewController, animated: true)
        }
        viewController.didSelectExportCSVClosure = { [weak self] in
            guard let self = self else { return }
            do {
                let url = try self.delegate.presentationDidStartExpensesCSVExport(self)
                let viewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.menuNavigationController?.present(viewController, animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    private func createSelectCurrencyViewController() -> SelectCurrencyScreenViewController {
        let currencies = delegate.presentationCurrencies(self)
        let selectedCurrency = delegate.presentationSelectedCurrency(self)
        let viewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
        viewController.backClosure = { [weak self] in
            self?.menuNavigationController?.popViewController(animated: true)
        }
        viewController.didSelectCurrencyClosure = { [weak self] currency in
            guard let self = self else { return }
            self.delegate.presentation(self, updateSelectedCurrency: currency)
        }
        return viewController
    }
    
    // MARK: Accounts Screen View Controller
    
    private weak var pushedAccoutsViewController: AccountsScreenViewController?
    private func pushAccountsViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let viewController = AccountsScreenViewController(accounts: accounts)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.addAccountClosure = { [weak self, weak navigationController] in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                let viewController = self.createPushingAddAccountViewController()
                self.pushedAddAccoutScreenViewController = viewController
                navigationController.pushViewController(viewController, animated: true)
            }
            viewController.deleteAccountClosure = { [weak self] account in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, deleteAccount: account)
                    self.dashboardViewController?.deleteAccount(account)
                } catch {
                    self.displayUnexpectedErrorDetailsScreen(error)
                }
            }
            viewController.editAccountClosure = { [weak self, weak navigationController] editingAccount in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                let viewController = self.createEditAccountViewController(editingAccount: editingAccount)
                self.pushedEditAccoutScreenViewController = viewController
                navigationController.pushViewController(viewController, animated: true)
            }
            viewController.orderAccountsClosure = { [weak self] accounts in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, orderAccounts: accounts)
                    self.dashboardViewController?.orderAccounts(accounts)
                } catch {
                    self.displayUnexpectedErrorDetailsScreen(error)
                }
            }
            pushedAccoutsViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push AccoutsViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: Add Accounts Screen View Controller
    
    private weak var pushedAddAccoutScreenViewController: AddAccountScreenViewController?
    
    private func createPushingAddAccountViewController() -> AddAccountScreenViewController {
        let backgroundColors = AccountBackgroundColors.variants
        let selectedCurrency = delegate.presentationSelectedCurrency(self)
        let viewController = AddAccountScreenViewController(backgroundColors: backgroundColors, selectedCurrency: selectedCurrency)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.selectCurrencyClosure = { [weak self] in
            guard let self = self else { return }
            let currencies = self.delegate.presentationCurrencies(self)
            let selectedCurrency = viewController.selectedCurrency
            let selectCurrencyViewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
            selectCurrencyViewController.backClosure = { [weak self] in
                guard let self = self else { return }
                self.menuNavigationController?.popViewController(animated: true)
            }
            selectCurrencyViewController.didSelectCurrencyClosure = { [weak self] currency in
                guard let self = self else { return }
                viewController.setSelectedCurrency(currency, animated: true)
                self.menuNavigationController?.popViewController(animated: true)
            }
            self.menuNavigationController?.pushViewController(selectCurrencyViewController, animated: true)
        }
        viewController.addAccountClosure = { [weak self] addingAccount in
            guard let self = self else { return }
            do {
                let addedAccount = try self.delegate.presentation(self, addAccount: addingAccount)
                self.menuNavigationController?.popViewController(animated: true)
                if let accountsViewController = self.pushedAccoutsViewController {
                    accountsViewController.addAccount(addedAccount)
                }
                self.dashboardViewController?.addAccount(addedAccount)
                self.editExpenseViewController?.addAccount(addedAccount)
                self.pushedAddExpenseViewController?.addAccount(addedAccount)
                self.pushedEditTemplateScreenViewController?.addAccount(addedAccount)
                self.pushedAddTemplateScreenViewController?.addAccount(addedAccount)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    private weak var presentedAddAccoutScreenViewController: AddAccountScreenViewController?
    private func presentAddAccountViewController(_ presentingViewController: UIViewController) {
        let backgroundColors = AccountBackgroundColors.variants
        let selectedCurrency = delegate.presentationSelectedCurrency(self)
        let viewController = AddAccountScreenViewController(backgroundColors: backgroundColors, selectedCurrency: selectedCurrency)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.dismiss(animated: true, completion: nil)
        }
        viewController.selectCurrencyClosure = { [weak self] in
            guard let self = self else { return }
            let currencies = self.delegate.presentationCurrencies(self)
            let selectedCurrency = viewController.selectedCurrency
            let selectCurrencyViewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
            selectCurrencyViewController.backClosure = {
                viewController.dismiss(animated: true, completion: nil)
            }
            selectCurrencyViewController.didSelectCurrencyClosure = { currency in
                viewController.setSelectedCurrency(currency, animated: true)
                viewController.dismiss(animated: true, completion: nil)
            }
            viewController.present(selectCurrencyViewController, animated: true, completion: nil)
        }
        viewController.addAccountClosure = { [weak self] addingAccount in
            guard let self = self else { return }
            do {
                let addedAccount = try self.delegate.presentation(self, addAccount: addingAccount)
                self.menuNavigationController?.dismiss(animated: true, completion: nil)
                if let accountsViewController = self.pushedAccoutsViewController {
                    accountsViewController.addAccount(addedAccount)
                }
                self.dashboardViewController?.addAccount(addedAccount)
                self.editExpenseViewController?.addAccount(addedAccount)
                self.pushedAddExpenseViewController?.addAccount(addedAccount)
                self.pushedEditTemplateScreenViewController?.addAccount(addedAccount)
                self.pushedAddTemplateScreenViewController?.addAccount(addedAccount)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        presentedAddAccoutScreenViewController = viewController
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: Edit Accounts Screen View Controller
    
    private weak var pushedEditAccoutScreenViewController: EditAccountScreenViewController?
    private func createEditAccountViewController(editingAccount: Account) -> EditAccountScreenViewController {
        let backgroundColors = AccountBackgroundColors.variants
        let viewController = EditAccountScreenViewController(editingAccount: editingAccount, backgroundColors: backgroundColors)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.selectCurrencyClosure = { [weak self] in
            guard let self = self else { return }
            let currencies = self.delegate.presentationCurrencies(self)
            let selectedCurrency = viewController.selectedCurrency
            let selectCurrencyViewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
            selectCurrencyViewController.backClosure = { [weak self] in
                guard let self = self else { return }
                self.menuNavigationController?.popViewController(animated: true)
            }
            selectCurrencyViewController.didSelectCurrencyClosure = { [weak self] currency in
                guard let self = self else { return }
                viewController.setSelectedCurrency(currency, animated: true)
                self.menuNavigationController?.popViewController(animated: true)
            }
            self.menuNavigationController?.pushViewController(selectCurrencyViewController, animated: true)
        }
        viewController.editAccountClosure = { [weak self] editingAccount in
            guard let self = self else { return }
            do {
                let editedAccount = try self.delegate.presentation(self, editAccount: editingAccount)
                self.menuNavigationController?.popViewController(animated: true)
                if let accountsViewController = self.pushedAccoutsViewController {
                    accountsViewController.editAccount(editedAccount)
                }
                self.dashboardViewController?.editAccount(editedAccount)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: - Templates Screen View Controller
    
    private weak var pushedTemplatesScreenViewController: TemplatesScreenViewController?
    
    private func pushTemplatesScreenViewController(_ navigationController: UINavigationController) {
        let templates = delegate.presentationExpenseTemplates(self)
        let viewController = TemplatesScreenViewController(templates: templates)
        viewController.addTemplateClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            self.pushAddTemplateScreenViewController(menuNavigationController)
        }
        viewController.didSelectTemplateClosure = { [weak self] template in
            guard let self = self else { return }
            guard let menuNavigationController =  self.menuNavigationController else { return }
            self.pushEditTemplateScreenViewController(menuNavigationController, expenseTemplate: template)
        }
        viewController.didReorderTemplatesClosure = { [weak self] reorderedTemplates in
            guard let self = self else { return }
            self.delegate.presentation(self, reorderExpenseTemplates: reorderedTemplates)
            self.dashboardViewController?.orderTemplates(reorderedTemplates)
        }
        viewController.didDeleteTemplateClosure = { [weak self] template in
            guard let self = self else { return }
            self.delegate.presentation(self, deleteExpenseTemplate: template)
            self.dashboardViewController?.deleteTemplate(template)
        }
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        pushedTemplatesScreenViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Add Template Screen View Controller
    
    private weak var pushedAddTemplateScreenViewController: AddTemplateScreenViewController?
    private func pushAddTemplateScreenViewController(_ navigationController: UINavigationController) {
        let categories = try! delegate.presentationCategories(self)
        let balanceAccounts = try! delegate.presentationAccounts(self)
        let viewController = AddTemplateScreenViewController(categories: categories, balanceAccounts: balanceAccounts)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.addTemplateClosure = { [weak self, weak navigationController] addingExpenseTemplate in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            let addedTemplate = self.delegate.presentation(self, addExpenseTemplate: addingExpenseTemplate)
            self.dashboardViewController?.addTemplate(addedTemplate)
            self.pushedTemplatesScreenViewController?.showTemplateAdded(addedTemplate)
            navigationController.popViewController(animated: true)
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddCategoryScreenViewController(viewController)
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddAccountViewController(viewController)
        }
        pushedAddTemplateScreenViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private weak var presentedAddTemplateScreenViewController: AddTemplateScreenViewController?
    private func presentAddTemplateScreenViewController(_ presentingViewController: UIViewController) {
        let categories = try! delegate.presentationCategories(self)
        let balanceAccounts = try! delegate.presentationAccounts(self)
        let viewController = AddTemplateScreenViewController(categories: categories, balanceAccounts: balanceAccounts)
        viewController.backClosure = { [weak viewController] in
            guard let viewController = viewController else { return }
            viewController.dismiss(animated: true, completion: nil)
        }
        viewController.addTemplateClosure = { [weak self, weak viewController] addingExpenseTemplate in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            let addedTemplate = self.delegate.presentation(self, addExpenseTemplate: addingExpenseTemplate)
            self.dashboardViewController?.addTemplate(addedTemplate)
            self.pushedTemplatesScreenViewController?.showTemplateAdded(addedTemplate)
            viewController.dismiss(animated: true, completion: nil)
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddCategoryScreenViewController(viewController)
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddAccountViewController(viewController)
        }
        self.presentedAddTemplateScreenViewController = viewController
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Edit Template Screen View Controller
    
    private weak var pushedEditTemplateScreenViewController: EditTemplateScreenViewController?
    private func pushEditTemplateScreenViewController(_ navigationController: UINavigationController, expenseTemplate: ExpenseTemplate) {
        let categories = try! delegate.presentationCategories(self)
        let balanceAccounts = try! delegate.presentationAccounts(self)
        let viewController = EditTemplateScreenViewController(expenseTemplate: expenseTemplate, categories: categories, balanceAccounts: balanceAccounts)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.editTemplateClosure = { [weak self, weak navigationController] editingTemplate in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            let editedTemplate = self.delegate.presentation(self, editExpenseTemplate: editingTemplate)
            self.dashboardViewController?.editTemplate(editedTemplate)
            self.pushedTemplatesScreenViewController?.showTemplateUpdated(editedTemplate)
            navigationController.popViewController(animated: true)
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddCategoryScreenViewController(viewController)
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddAccountViewController(viewController)
        }
        pushedEditTemplateScreenViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Import CSV Screen
    
    private func createImportCSVScreen() -> UIDocumentPickerViewController {
        let controller = ImportCSVScreenViewController()
        controller.didPickDocument = { [weak self] url in
            guard let self = self else { return }
            self.delegate.presentation(self, didPickDocumentAt: url)
        }
        return controller
    }
    
    // MARK: - Unexpected Error Alert Screen
    
    private weak var unexpectedErrorAlertScreenViewController: UnexpectedErrorAlertScreenViewController?
    
    private func presentUnexpectedErrorAlertScreen(_ error: Swift.Error) {
        let viewController = UnexpectedErrorAlertScreenViewController(title: nil, message: nil, preferredStyle: .alert)
        viewController.seeDetailsClosure = { [weak self] in
            guard let self = self else { return }
            viewController.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.displayUnexpectedErrorDetailsScreen(error)
            }
            self.unexpectedErrorAlertScreenViewController = nil
        }
        viewController.okClosure = { [weak self] in
            guard let self = self else { return }
            viewController.dismiss(animated: true, completion: nil)
            self.unexpectedErrorAlertScreenViewController = nil
        }
        unexpectedErrorAlertScreenViewController = viewController
        self.menuNavigationController?.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: Unexpected Error Details Screen
    
    private weak var unexpectedErrorDetailsScreenViewController: UnexpectedErrorDetailsScreenViewController?
    
    private func displayUnexpectedErrorDetailsScreen(_ error: Swift.Error) {
        let viewController = UnexpectedErrorDetailsScreenViewController(error: error)
        viewController.modalPresentationStyle = .fullScreen
        viewController.backClosure = {
            viewController.dismiss(animated: true, completion: nil)
        }
        viewController.shareClosire = { data in
            let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            viewController.present(activityViewController, animated: true, completion: nil)
        }
        unexpectedErrorDetailsScreenViewController = viewController
        self.menuNavigationController?.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Statistic Screen
    
    private weak var statisticScreen: StatisticScreenViewController?
    
    private func createStatisticScreen() -> StatisticScreenViewController {
        let viewController = StatisticScreenViewController()
        viewController.monthsClosure = { [weak self] in
            guard let self = self else { return [] }
            let months = self.delegate.presentationExpensesMonths(self)
            return months
        }
        viewController.expensesClosure = { [weak self] month in
            guard let self = self else { return [] }
            let expenses = try! self.delegate.presentationMonthExpenses(self, month: month)
            return expenses
        }
        return viewController
    }
    
}

extension UIWindow {
    
    func showSnackbarViewAnimated(_ view: UIView, completionHandler: ((Bool) -> ())?) {
        addSubview(view)
        let x: CGFloat = 16
        let width = bounds.width - 2 * x
        let height = view.sizeThatFits(CGSize(width: width, height: bounds.height)).height
        let y = bounds.height - height - safeAreaInsets.bottom - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        view.frame = frame
        setNeedsLayout()
        layoutIfNeeded()
        view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        } completion: { finished in
            completionHandler?(finished)
        }
    }
    
    func hideSnackbarViewAnimated(_ view: UIView, completionHandler: ((Bool) -> ())?) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0
        } completion: { finished in
            view.removeFromSuperview()
            completionHandler?(finished)
        }
    }
    
}
