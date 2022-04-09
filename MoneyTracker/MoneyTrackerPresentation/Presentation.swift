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
    func presentation(_ presentation: Presentation, editCategory editingCategory: EditingCategory) throws -> Category
    func presentation(_ presentation: Presentation, deleteCategory category: Category) throws
    func presentation(_ presentation: Presentation, orderCategories categories: [Category]) throws
    func presentationCurrencies(_ presentation: Presentation) -> [Currency]
    func presentationSelectedCurrency(_ presentation: Presentation) throws -> Currency
    func presentation(_ presentation: Presentation, updateSelectedCurrency currency: Currency)
    func presentationAccounts(_ presentation: Presentation) throws -> [Account]
    func presentation(_ presentation: Presentation, deleteAccount category: Account) throws
    func presentation(_ presentation: Presentation, addAccount addingAccount: AddingAccount) throws -> Account
    func presentation(_ presentation: Presentation, editAccount editingAccount: Account) throws -> Account
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
    func presentation(_ presentation: Presentation, addTopUpAccount addingTopUpAccount: AddingTopUpAccount) throws -> TopUpAccount
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
        menuViewController.dashboard()
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
        let templates = (try? delegate.presentationExpenseTemplates(self)) ?? []
        let viewController = DashboardScreenViewController(categories: categories, accounts: accounts, templates: templates)
        viewController.addExpenseClosure = { [weak self] category in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushAddExpenseViewController(menuNavigationController, selectedCategory: category)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.addCategoryClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentAddCategoryScreenViewController(viewController)
        }
        viewController.transferClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushAddTransferViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.topUpAccountClosure = { [weak self] account in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushTopUpAccountViewController(menuNavigationController, selectedAccount: account)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.addAccountClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            do {
                try self.presentAddAccountViewController(viewController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.addTemplateClosure = { [weak self] in
            guard let self = self else { return }
            do {
                try self.presentAddTemplateScreenViewController(viewController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.useTemplateClosure = { [weak self] template in
            guard let self = self else { throw Error("") }
            do {
                let addedExpense = try self.delegate.presentation(self, useTemplate: template)
                self.displayExpenseAddedSnackbarViewController(template: template, expense: addedExpense)
                self.historyViewController?.insertExpense(addedExpense)
                self.statisticScreen?.addExpense(addedExpense)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        return viewController
    }
    
    // MARK: Add Expense View Controller
    
    private weak var pushedAddExpenseViewController: AddExpenseScreenViewController?
    private func pushAddExpenseViewController(_ navigationController: UINavigationController, selectedCategory: Category?) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let categories = try delegate.presentationCategories(self)
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
                    throw error
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
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedAddExpenseViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push AddExpenseViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: Transfer View Controller
    
    private weak var pushedAddTransferViewController: AddTransferScreenViewController?
    private func pushAddTransferViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let viewController = AddTransferScreenViewController(accounts: accounts)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.addAccountClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.addTransferClosure = { [weak self, weak viewController] addingTransfer in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    _ = try self.delegate.presentation(self, addTransfer: addingTransfer)
                    viewController.dismiss(animated: true, completion: nil)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedAddTransferViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push TransferViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: Top Up Account View Controller
    
    private weak var pushedTopUpAccountViewController: TopUpAccountScreenViewController?
    private func pushTopUpAccountViewController(_ navigationController: UINavigationController, selectedAccount: Account) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let viewController = TopUpAccountScreenViewController(accounts: accounts, selectedAccount: selectedAccount)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.addAccountClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.addTopUpAccountClosure = { [weak self, weak viewController] addingTopUpAccount in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    _ = try self.delegate.presentation(self, addTopUpAccount: addingTopUpAccount)
                    viewController.dismiss(animated: true, completion: nil)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedTopUpAccountViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push TopUpAccountViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: ExpenseAddedSnackbarView
    
    private var expenseAddedSnackbarViewControllers: [ExpenseAddedSnackbarViewController] = []
    private func displayExpenseAddedSnackbarViewController(template: ExpenseTemplate, expense: Expense) {
        let viewController = ExpenseAddedSnackbarViewController(template: template, expense: expense)
        let view = ExpenseAddedSnackbarView()
        viewController.expenseAddedSnackbarView = view
        expenseAddedSnackbarViewControllers.append(viewController)
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            timer.invalidate()
            self.window.hideSnackbarViewAnimated(view, completionHandler: nil)
            if let firstIndex = self.expenseAddedSnackbarViewControllers.firstIndex(where: { $0 === viewController }) {
                self.expenseAddedSnackbarViewControllers.remove(at: firstIndex)
            }
        }
        window.showSnackbarViewAnimated(view, completionHandler: nil)
        viewController.okClosure = { [weak self] in
            guard let self = self else { return }
            timer.invalidate()
            self.window.hideSnackbarViewAnimated(view, completionHandler: nil)
            if let firstIndex = self.expenseAddedSnackbarViewControllers.firstIndex(where: { $0 === viewController }) {
                self.expenseAddedSnackbarViewControllers.remove(at: firstIndex)
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
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushEditExpenseViewController(menuNavigationController, expense: expense)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        historyViewController = viewController
        return viewController
    }
    
    // MARK: Edit Expense View Controller
    
    private weak var pushedEditExpenseViewController: EditExpenseScreenViewController?
    private func pushEditExpenseViewController(_ navigationController: UINavigationController, expense: Expense) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let categories = try delegate.presentationCategories(self)
            let viewController = EditExpenseScreenViewController(expense: expense, categories: categories, balanceAccounts: accounts)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.addAccountClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
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
            pushedEditExpenseViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push EditExpenseViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Statistic Screen
    
    private weak var statisticScreen: StatisticScreenViewController?
    private func createStatisticScreen() -> StatisticScreenViewController {
        let viewController = StatisticScreenViewController()
        viewController.monthsClosure = { [weak self] in
            guard let self = self else { return [] }
            let months = (try? self.delegate.presentationExpensesMonths(self)) ?? []
            return months
        }
        viewController.expensesClosure = { [weak self] month in
            guard let self = self else { return [] }
            do {
                let expenses = try self.delegate.presentationMonthExpenses(self, month: month)
                return expenses
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                return []
            }
        }
        return viewController
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
        let viewController = AddCategoryScreenViewController(categoryColors: CategoryBackgroundColors.variants, categoryIconName: CategoryIconNames.variant1)
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
                self.pushedEditExpenseViewController?.addCategory(addedCategory)
                self.pushedEditTemplateScreenViewController?.addCategory(addedCategory)
                self.pushedAddTemplateScreenViewController?.addCategory(addedCategory)
                navigationController.popViewController(animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.selectIconClosure = { [weak self] color in
            guard let self = self else { return }
            let selectIconViewController = self.createSelectIconViewController(
                iconColor: color,
                onSelectIcon: { [weak viewController] iconName in
                    viewController?.showCategoryIcon(iconName: iconName)
                }
            )
            self.menuNavigationController?.present(selectIconViewController, animated: true)
        }
        self.pushedAddCategoryViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private var presentedAddCategoryViewController: AddCategoryScreenViewController?
    private func presentAddCategoryScreenViewController(_ presentingViewController: UIViewController) {
        let viewController = AddCategoryScreenViewController(categoryColors: CategoryBackgroundColors.variants, categoryIconName: CategoryIconNames.variant1)
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
                self.pushedEditExpenseViewController?.addCategory(addedCategory)
                self.pushedEditTemplateScreenViewController?.addCategory(addedCategory)
                self.pushedAddTemplateScreenViewController?.addCategory(addedCategory)
                viewController.dismiss(animated: true, completion: nil)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.selectIconClosure = { [weak self, weak viewController] color in
            guard let self = self else { return }
            let selectIconViewController = self.createSelectIconViewController(
                iconColor: color,
                onSelectIcon: { iconName in
                    viewController?.showCategoryIcon(iconName: iconName)
                }
            )
            viewController?.present(selectIconViewController, animated: true)
        }
        presentedAddCategoryViewController = viewController
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: Edit Category View Controller
    
    private weak var pushedEditCategoryViewController: EditCategoryScreenViewController?
    private func pushEditCategoryScreenViewController(_ navigationController: UINavigationController, category: Category) {
        let viewController = EditCategoryScreenViewController(category: category, categoryColors: CategoryBackgroundColors.variants)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.editCategoryClosure = { [weak self, weak navigationController] editingCategory in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            do {
                let editedCategory = try self.delegate.presentation(self, editCategory: editingCategory)
                self.pushedCategoriesViewController?.editCategory(editedCategory)
                self.dashboardViewController?.editCategory(editedCategory)
                navigationController.popViewController(animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        viewController.selectIconClosure = { [weak self] color in
            guard let self = self else { return }
            let selectIconViewController = self.createSelectIconViewController(
                iconColor: color,
                onSelectIcon: { [weak viewController] iconName in
                    viewController?.showCategoryIcon(iconName: iconName)
                }
            )
            navigationController.present(selectIconViewController, animated: true)
        }
        pushedEditCategoryViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Select Icon View Controller
    
    private func createSelectIconViewController(
        iconColor: UIColor,
        onSelectIcon: @escaping (String) -> Void
    ) -> SelectIconScreenViewController {
        let viewController = SelectIconScreenViewController(iconNames: CategoryIconNames.variants, iconColor: iconColor)
        viewController.didSelectIconClosure = { [weak viewController] iconName in
            onSelectIcon(iconName)
            viewController?.dismiss(animated: true)
        }
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
        viewController.didSelectCurrencyClosure = { [weak self, weak viewController] in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            do {
                try self.presentSelectCurrencyViewController(viewController, selectedCurrency: nil)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
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
            do {
                try self.pushTemplatesScreenViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                
            }
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
    
    // MARK: Select Currency View Controller
    
    private func presentSelectCurrencyViewController(_ presentingViewController: UIViewController, selectedCurrency: Currency?) throws {
        do {
            let currencies = delegate.presentationCurrencies(self)
            let selectedCurrency = try selectedCurrency ?? delegate.presentationSelectedCurrency(self)
            let viewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak presentingViewController] in
                guard let presentingViewController = presentingViewController else { return }
                presentingViewController.dismiss(animated: true, completion: nil)
            }
            viewController.didSelectCurrencyClosure = { [weak self] currency in
                guard let self = self else { return }
                self.delegate.presentation(self, updateSelectedCurrency: currency)
            }
            presentingViewController.present(viewController, animated: true, completion: nil)
        } catch {
            let error = Error("Cannot present SelectCurrencyViewController\n\(error)")
            throw error
        }
    }
    
    private func pushSelectCurrencyViewController(_ navigationController: UINavigationController, selectedCurrency: Currency?) throws {
        do {
            let currencies = delegate.presentationCurrencies(self)
            let selectedCurrency = try selectedCurrency ?? delegate.presentationSelectedCurrency(self)
            let viewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.didSelectCurrencyClosure = { [weak self] currency in
                guard let self = self else { return }
                self.delegate.presentation(self, updateSelectedCurrency: currency)
            }
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push SelectCurrencyViewController\n\(error)")
            throw error
        }
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
                do {
                    try self.pushAddAccountViewController(navigationController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
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
                self.pushEditAccountViewController(navigationController, editingAccount: editingAccount)
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
    private func pushAddAccountViewController(_ navigationController: UINavigationController) throws {
        do {
            let backgroundColors = AccountBackgroundColors.variants
            let selectedCurrency = try delegate.presentationSelectedCurrency(self)
            let viewController = AddAccountScreenViewController(backgroundColors: backgroundColors, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.selectCurrencyClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    let selectedCurrency = viewController.selectedCurrency
                    try self.presentSelectCurrencyViewController(viewController, selectedCurrency: selectedCurrency)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.addAccountClosure = { [weak self, weak navigationController] addingAccount in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    let addedAccount = try self.delegate.presentation(self, addAccount: addingAccount)
                    navigationController.popViewController(animated: true)
                    if let accountsViewController = self.pushedAccoutsViewController {
                        accountsViewController.addAccount(addedAccount)
                    }
                    self.dashboardViewController?.addAccount(addedAccount)
                    self.pushedEditExpenseViewController?.addAccount(addedAccount)
                    self.pushedAddExpenseViewController?.addAccount(addedAccount)
                    self.pushedEditTemplateScreenViewController?.addAccount(addedAccount)
                    self.pushedAddTransferViewController?.addAccount(addedAccount)
                    self.pushedTopUpAccountViewController?.addAccount(addedAccount)
                    self.pushedAddTemplateScreenViewController?.addAccount(addedAccount)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedAddAccoutScreenViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push AddAccountViewController\n\(error)")
            throw error
        }
        
    }
    
    private weak var presentedAddAccoutScreenViewController: AddAccountScreenViewController?
    private func presentAddAccountViewController(_ presentingViewController: UIViewController) throws {
        do {
            let backgroundColors = AccountBackgroundColors.variants
            let selectedCurrency = try delegate.presentationSelectedCurrency(self)
            let viewController = AddAccountScreenViewController(backgroundColors: backgroundColors, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak self] in
                guard let self = self else { return }
                self.menuNavigationController?.dismiss(animated: true, completion: nil)
            }
            viewController.selectCurrencyClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    let selectedCurrency = viewController.selectedCurrency
                    try self.presentSelectCurrencyViewController(viewController, selectedCurrency: selectedCurrency)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
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
                    self.pushedEditExpenseViewController?.addAccount(addedAccount)
                    self.pushedAddExpenseViewController?.addAccount(addedAccount)
                    self.pushedEditTemplateScreenViewController?.addAccount(addedAccount)
                    self.pushedAddTransferViewController?.addAccount(addedAccount)
                    self.pushedTopUpAccountViewController?.addAccount(addedAccount)
                    self.pushedAddTemplateScreenViewController?.addAccount(addedAccount)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            presentedAddAccoutScreenViewController = viewController
            presentingViewController.present(viewController, animated: true, completion: nil)
        } catch {
            let error = Error("Cannot present AddAccountViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: Edit Accounts Screen View Controller
    
    private weak var pushedEditAccoutScreenViewController: EditAccountScreenViewController?
    private func pushEditAccountViewController(_ navigationController: UINavigationController, editingAccount: Account) {
        let backgroundColors = AccountBackgroundColors.variants
        let viewController = EditAccountScreenViewController(editingAccount: editingAccount, backgroundColors: backgroundColors)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.selectCurrencyClosure = { [weak self, weak navigationController] in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            let currencies = self.delegate.presentationCurrencies(self)
            let selectedCurrency = viewController.selectedCurrency
            let selectCurrencyViewController = SelectCurrencyScreenViewController(currencies: currencies, selectedCurrency: selectedCurrency)
            selectCurrencyViewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            selectCurrencyViewController.didSelectCurrencyClosure = { [weak navigationController] currency in
                guard let navigationController = navigationController else { return }
                viewController.setSelectedCurrency(currency, animated: true)
                navigationController.popViewController(animated: true)
            }
            navigationController.pushViewController(selectCurrencyViewController, animated: true)
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
        pushedEditAccoutScreenViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Templates Screen View Controller
    
    private weak var pushedTemplatesScreenViewController: TemplatesScreenViewController?
    private func pushTemplatesScreenViewController(_ navigationController: UINavigationController) throws {
        do {
            let templates = try delegate.presentationExpenseTemplates(self)
            let viewController = TemplatesScreenViewController(templates: templates)
            viewController.addTemplateClosure = { [weak self] in
                guard let self = self else { return }
                guard let menuNavigationController = self.menuNavigationController else { return }
                do {
                    try self.pushAddTemplateScreenViewController(menuNavigationController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.didSelectTemplateClosure = { [weak self] template in
                guard let self = self else { return }
                guard let menuNavigationController =  self.menuNavigationController else { return }
                do {
                    try self.pushEditTemplateScreenViewController(menuNavigationController, expenseTemplate: template)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.didReorderTemplatesClosure = { [weak self] reorderedTemplates in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, reorderExpenseTemplates: reorderedTemplates)
                    self.dashboardViewController?.orderTemplates(reorderedTemplates)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.didDeleteTemplateClosure = { [weak self] template in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, deleteExpenseTemplate: template)
                    self.dashboardViewController?.deleteTemplate(template)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            pushedTemplatesScreenViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push TemplatesScreenViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Add Template Screen View Controller
    
    private weak var pushedAddTemplateScreenViewController: AddTemplateScreenViewController?
    private func pushAddTemplateScreenViewController(_ navigationController: UINavigationController) throws {
        do {
            let categories = try delegate.presentationCategories(self)
            let balanceAccounts = try delegate.presentationAccounts(self)
            let viewController = AddTemplateScreenViewController(categories: categories, balanceAccounts: balanceAccounts)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.addTemplateClosure = { [weak self, weak navigationController] addingExpenseTemplate in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    let addedTemplate = try self.delegate.presentation(self, addExpenseTemplate: addingExpenseTemplate)
                    self.dashboardViewController?.addTemplate(addedTemplate)
                    self.pushedTemplatesScreenViewController?.showTemplateAdded(addedTemplate)
                    navigationController.popViewController(animated: true)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.addCategoryClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                self.presentAddCategoryScreenViewController(viewController)
            }
            viewController.addAccountClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedAddTemplateScreenViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push AddTemplateScreenViewController\n\(error)")
            throw error
        }
    }
    
    private weak var presentedAddTemplateScreenViewController: AddTemplateScreenViewController?
    private func presentAddTemplateScreenViewController(_ presentingViewController: UIViewController) throws {
        do {
            let categories = try delegate.presentationCategories(self)
            let balanceAccounts = try delegate.presentationAccounts(self)
            let viewController = AddTemplateScreenViewController(categories: categories, balanceAccounts: balanceAccounts)
            viewController.backClosure = { [weak viewController] in
                guard let viewController = viewController else { return }
                viewController.dismiss(animated: true, completion: nil)
            }
            viewController.addTemplateClosure = { [weak self, weak viewController] addingExpenseTemplate in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    let addedTemplate = try self.delegate.presentation(self, addExpenseTemplate: addingExpenseTemplate)
                    self.dashboardViewController?.addTemplate(addedTemplate)
                    self.pushedTemplatesScreenViewController?.showTemplateAdded(addedTemplate)
                    viewController.dismiss(animated: true, completion: nil)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.addCategoryClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                self.presentAddCategoryScreenViewController(viewController)
            }
            viewController.addAccountClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            self.presentedAddTemplateScreenViewController = viewController
            presentingViewController.present(viewController, animated: true, completion: nil)
        } catch {
            let error = Error("Cannot present AddTemplateScreenViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Edit Template Screen View Controller
    
    private weak var pushedEditTemplateScreenViewController: EditTemplateScreenViewController?
    private func pushEditTemplateScreenViewController(_ navigationController: UINavigationController, expenseTemplate: ExpenseTemplate) throws {
        do {
            let categories = try delegate.presentationCategories(self)
            let balanceAccounts = try delegate.presentationAccounts(self)
            let viewController = EditTemplateScreenViewController(expenseTemplate: expenseTemplate, categories: categories, balanceAccounts: balanceAccounts)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.editTemplateClosure = { [weak self, weak navigationController] editingTemplate in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    let editedTemplate = try self.delegate.presentation(self, editExpenseTemplate: editingTemplate)
                    self.dashboardViewController?.editTemplate(editedTemplate)
                    self.pushedTemplatesScreenViewController?.showTemplateUpdated(editedTemplate)
                    navigationController.popViewController(animated: true)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.addCategoryClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                self.presentAddCategoryScreenViewController(viewController)
            }
            viewController.addAccountClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    try self.presentAddAccountViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedEditTemplateScreenViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push EditTemplateScreenViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Import CSV Screen
    
    private func createImportCSVScreen() -> UIDocumentPickerViewController {
        let controller = ImportCSVScreenViewController()
        controller.didPickDocument = { [weak self] url in
            guard let self = self else { return }
            do {
                try self.delegate.presentation(self, didPickDocumentAt: url)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return controller
    }
    
    public func showDidImportExpensesFile(_ file: ImportedExpensesFile) {
        dashboardViewController?.addAccounts(file.importedAccounts)
        dashboardViewController?.addCategories(file.importedCategories)
        historyViewController?.insertExpenses(file.importedExpenses)
        statisticScreen?.addExpenses(file.importedExpenses)
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
        viewController.shareClosure = { data in
            let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            viewController.present(activityViewController, animated: true, completion: nil)
        }
        unexpectedErrorDetailsScreenViewController = viewController
        self.menuNavigationController?.present(viewController, animated: true, completion: nil)
    }
    
}

extension UIWindow {
    
    func showSnackbarViewAnimated(_ view: UIView, completionHandler: ((Bool) -> ())?) {
        addSubview(view)
        let x: CGFloat = 16
        let width = bounds.width - 2 * x
        let height = view.sizeThatFits(CGSize(width: width, height: bounds.height)).height
        let y = safeAreaInsets.top
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
