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
    func presentationCategories(_ presentation: Presentation) -> [Category]
    func presentation(_ presentation: Presentation, addCategory addingCategory: AddingCategory)
    func presentation(_ presentation: Presentation, deleteCategory category: Category)
    func presentation(_ presentation: Presentation, sortCategories categories: [Category])
    func presentation(_ presentation: Presentation, editCategory editingCategory: Category)
    func presentationCurrencies(_ presentation: Presentation) -> [Currency]
    func presentationSelectedCurrency(_ presentation: Presentation) -> Currency
    func presentation(_ presentation: Presentation, updateSelectedCurrency currency: Currency)
    func presentationAccounts(_ presentation: Presentation) throws -> [Account]
    func presentation(_ presentation: Presentation, deleteAccount category: Account) throws
    func presentationAccountBackgroundColors(_ presentation: Presentation) -> [UIColor]
    func presentation(_ presentation: Presentation, addAccount addingAccount: AddingAccount) throws -> Account
    func presentation(_ presentation: Presentation, editAccount editingAccount: Account) throws -> Account
    func presentation(_ presentation: Presentation, orderAccounts accounts: [Account]) throws
    func presentationExpenseTemplates(_ presentation: Presentation) -> [ExpenseTemplate]
    func presentationExpenseTemplates(_ presentation: Presentation, limit: Int) -> [ExpenseTemplate]
    func presentation(_ presentation: Presentation, reorderExpenseTemplates reorderedExpenseTemplates: [ExpenseTemplate])
    func presentation(_ presentation: Presentation, deleteExpenseTemplate expenseTemplate: ExpenseTemplate)
    func presentation(_ presentation: Presentation, addExpenseTemplate addingExpenseTemplate: AddingExpenseTemplate)
    func presentation(_ presentation: Presentation, editExpenseTemplate editingExpenseTemplate: EditingExpenseTemplate)
    func presentation(_ presentation: Presentation, didPickDocumentAt url: URL)
    func presentation(_ presentation: Presentation, searchExpensesFrom fromDate: Date, toDate: Date)
    func presentationDayExpenses(_ presentation: Presentation, day: Date) throws -> [Expense]
    func presentation(_ presentation: Presentation, addExpense addingExpense: AddingExpense) throws -> Expense
    func presentation(_ presentation: Presentation, deleteExpense deletingExpense: Expense) throws
    func presentationExpenses(_ presentation: Presentation) throws -> [Expense]
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
        menuViewController.statistic()
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
        let templates = delegate.presentationExpenseTemplates(self, limit: 5)
        let viewController = DashboardScreenViewController(templates: templates)
        viewController.didTapOnAddExpenseClosure = { [weak self] in
            guard let self = self else { return }
            let addExpenseViewController = self.createAddExpenseViewController()
            self.addExpenseViewController = addExpenseViewController
            self.menuNavigationController?.pushViewController(addExpenseViewController, animated: true)
        }
        viewController.addExpenseClosure = { [weak self] addingExpense in
            guard let self = self else { throw Error("") }
            do {
                let addedExpense = try self.delegate.presentation(self, addExpense: addingExpense)
                self.historyViewController?.insertExpense(addedExpense)
                return addedExpense
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
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
                try self.delegate.presentation(self, deleteExpense: deletingExpense)
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
            }
        }
        historyViewController = viewController
        return viewController
    }
    
    // MARK: Add Expense View Controller
    
    private weak var addExpenseViewController: AddExpenseScreenViewController?
    
    private func createAddExpenseViewController() -> AddExpenseScreenViewController {
        let accounts = try! delegate.presentationAccounts(self)
        let categories = delegate.presentationCategories(self)
        let viewController = AddExpenseScreenViewController(accounts: accounts, categories: categories)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.dayExpensesClosure = { [weak self] day in
            guard let self = self else { return [] }
            do {
                let dayExpenses = try self.delegate.presentationDayExpenses(self, day: day)
                return dayExpenses
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
                return []
            }
        }
        viewController.addExpenseClosure = { [weak self] addingExpense in
            guard let self = self else { throw Error("") }
            do {
                let addedExpense = try self.delegate.presentation(self, addExpense: addingExpense)
                self.historyViewController?.insertExpense(addedExpense)
                return addedExpense
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        viewController.deleteExpenseClosure = { [weak self] expense in
            guard let self = self else { return }
            do {
                try self.delegate.presentation(self, deleteExpense: expense)
                self.historyViewController?.deleteExpense(expense)
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
            }
        }
        addExpenseViewController = viewController
        return viewController
    }
    
    // MARK: Categories Navigation Controller
    
    private weak var categoriesNavigationController: UINavigationController?
    
    // MARK: Categories View Controller
    
    private weak var categoriesViewController: CategoriesScreenViewController?
    
    private func createCategoriesViewController() -> CategoriesScreenViewController {
        let categories = delegate.presentationCategories(self)
        let viewController = CategoriesScreenViewController(categories: categories)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.didSelectAddCategoryClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createAddCategoryScreenViewController()
            self.addCategoryViewController = viewController
            self.menuNavigationController?.present(viewController, animated: true, completion: nil)
        }
        viewController.didDeleteCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            self.delegate.presentation(self, deleteCategory: category)
        }
        viewController.didSortCategoriesClosure = { [weak self] categories in
            guard let self = self else { return }
            self.delegate.presentation(self, sortCategories: categories)
        }
        viewController.didSelectCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            let viewController = self.createEditCategoryScreenViewController(category: category)
            self.editCategoryViewController = viewController
            self.menuNavigationController?.present(viewController, animated: true, completion: nil)
        }
        return viewController
    }
    
    // MARK: Settings Navigation Controller
    
    private weak var settingsNavigationController: UINavigationController?
    
    // MARK: Add Category View Controller
    
    private var addCategoryViewController: AddCategoryScreenViewController?
        
    private func createAddCategoryScreenViewController() -> AddCategoryScreenViewController {
        let viewController = AddCategoryScreenViewController()
        viewController.addCategoryClosure = { [weak self] addingCategory in
            guard let self = self else { return }
            self.delegate.presentation(self, addCategory: addingCategory)
            let categories = self.delegate.presentationCategories(self)
            self.categoriesViewController?.updateCategories(categories)
            viewController.dismiss(animated: true, completion: nil)
        }
        return viewController
    }
    
    // MARK: Add Category View Controller
    
    private weak var editCategoryViewController: EditCategoryScreenViewController?
        
    private func createEditCategoryScreenViewController(category: Category) -> EditCategoryScreenViewController {
        let viewController = EditCategoryScreenViewController(category: category)
        viewController.editCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            self.delegate.presentation(self, editCategory: category)
            let categories = self.delegate.presentationCategories(self)
            self.categoriesViewController?.updateCategories(categories)
            viewController.dismiss(animated: true, completion: nil)
        }
        return viewController
    }
    
    // MARK: - Settings Screen View Controller
    
    private weak var settingsScreenViewController: SettingsScreenViewController?
    
    private func createSettingsScreenViewController() -> SettingsScreenViewController {
        let viewController = SettingsScreenViewController()
        viewController.didSelectCategoriesClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createCategoriesViewController()
            self.categoriesViewController = viewController
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.didSelectCurrencyClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createSelectCurrencyViewController()
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.didSelectAccountsClosure = { [weak self] in
            guard let self = self else { return }
            do {
                let viewController = try self.createAccountsViewController()
                self.accoutsViewController = viewController
                self.menuNavigationController?.pushViewController(viewController, animated: true)
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
            }
            
        }
        viewController.didSelectTemplatesClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createTemplatesScreenViewController()
            self.templatesScreenViewController = viewController
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.didSelectImportCSVClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createImportCSVScreen()
            self.menuNavigationController?.present(viewController, animated: true)
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
    
    private weak var accoutsViewController: AccountsScreenViewController?
    
    private func createAccountsViewController() throws -> AccountsScreenViewController {
        let accounts = try delegate.presentationAccounts(self)
        let viewController = AccountsScreenViewController(accounts: accounts)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createAddAccountViewController()
            self.addAccoutScreenViewController = viewController
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.deleteAccountClosure = { [weak self] account in
            guard let self = self else { return }
            do {
                try self.delegate.presentation(self, deleteAccount: account)
            } catch {
                self.displayUnexpectedErrorDetailsScreen(error)
            }
        }
        viewController.editAccountClosure = { [weak self] editingAccount in
            guard let self = self else { return }
            let viewController = self.createEditAccountViewController(editingAccount: editingAccount)
            self.editAccoutScreenViewController = viewController
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.orderAccountsClosure = { [weak self] accounts in
            guard let self = self else { return }
            do {
                try self.delegate.presentation(self, orderAccounts: accounts)
            } catch {
                self.displayUnexpectedErrorDetailsScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: Add Accounts Screen View Controller
    
    private weak var addAccoutScreenViewController: AddAccountScreenViewController?
    
    private func createAddAccountViewController() -> AddAccountScreenViewController {
        let backgroundColors = delegate.presentationAccountBackgroundColors(self)
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
                if let accountsViewController = self.accoutsViewController {
                    accountsViewController.addAccount(addedAccount)
                }
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: Edit Accounts Screen View Controller
    
    private weak var editAccoutScreenViewController: EditAccountScreenViewController?
    
    private func createEditAccountViewController(editingAccount: Account) -> EditAccountScreenViewController {
        let backgroundColors = delegate.presentationAccountBackgroundColors(self)
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
                if let accountsViewController = self.accoutsViewController {
                    accountsViewController.editAccount(editedAccount)
                }
            } catch {
                self.displayUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: - Templates Screen View Controller
    
    private weak var templatesScreenViewController: TemplatesScreenViewController?
    
    private func createTemplatesScreenViewController() -> TemplatesScreenViewController {
        let templates = delegate.presentationExpenseTemplates(self)
        let viewController = TemplatesScreenViewController(templates: templates)
        viewController.addTemplateClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createAddTemplateScreenViewController()
            self.menuNavigationController?.present(viewController, animated: true)
        }
        viewController.didSelectTemplateClosure = { [weak self] template in
            guard let self = self else { return }
            let viewController = self.createEditTemplateScreenViewController(expenseTemplate: template)
            self.menuNavigationController?.present(viewController, animated: true)
        }
        viewController.didReorderTemplatesClosure = { [weak self] reorderedTemplates in
            guard let self = self else { return }
            self.delegate.presentation(self, reorderExpenseTemplates: reorderedTemplates)
        }
        viewController.didDeleteTemplateClosure = { [weak self] template in
            guard let self = self else { return }
            self.delegate.presentation(self, deleteExpenseTemplate: template)
        }
        viewController.backClosure = { [weak self] in
            self?.templatesScreenViewController = nil
            self?.menuNavigationController?.popViewController(animated: true)
        }
        return viewController
    }
    
    public func showExpenseTemplateAdded(_ expenseTemplate: ExpenseTemplate) {
        templatesScreenViewController?.showTemplateAdded(expenseTemplate)
    }
    
    public func showExpenseTemplateUpdated(_ updatedTemplate: ExpenseTemplate) {
        templatesScreenViewController?.showTemplateUpdated(updatedTemplate)
        dashboardViewController?.showTemplateUpdated(updatedTemplate)
    }
    
    public func showExpenseTemplatesReordered(_ reorderedExpenseTemplates: [ExpenseTemplate]) {
        dashboardViewController?.showTemplatesReordered(reorderedExpenseTemplates)
    }
    
    public func showExpenseTemplateRemoved(_ expenseTemplate: ExpenseTemplate) {
        dashboardViewController?.showTemplateRemoved(templateId: expenseTemplate.id)
    }
    
    // MARK: - Add Template Screen View Controller
    
    private func createAddTemplateScreenViewController() -> AddTemplateScreenViewController {
        let categories = delegate.presentationCategories(self)
        let balanceAccounts = try! delegate.presentationAccounts(self)
        let viewController = AddTemplateScreenViewController(categories: categories, balanceAccounts: balanceAccounts)
        viewController.backClosure = { [weak self] in
            self?.menuNavigationController?.dismiss(animated: true)
        }
        viewController.addTemplateClosure = { [weak self] addingExpenseTemplate in
            guard let self = self else { return }
            self.delegate.presentation(self, addExpenseTemplate: addingExpenseTemplate)
            self.menuNavigationController?.dismiss(animated: true)
        }
        return viewController
    }
    
    // MARK: - Edit Template Screen View Controller
    
    private func createEditTemplateScreenViewController(expenseTemplate: ExpenseTemplate) -> EditTemplateScreenViewController {
        let categories = delegate.presentationCategories(self)
        let balanceAccounts = try! delegate.presentationAccounts(self)
        let viewController = EditTemplateScreenViewController(expenseTemplate: expenseTemplate, categories: categories, balanceAccounts: balanceAccounts)
        viewController.backClosure = { [weak self] in
            self?.menuNavigationController?.dismiss(animated: true)
        }
        viewController.editTemplateClosure = { [weak self] editingTemplate in
            guard let self = self else { return }
            self.delegate.presentation(self, editExpenseTemplate: editingTemplate)
            self.menuNavigationController?.dismiss(animated: true)
        }
        return viewController
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
    
    private func displayUnexpectedErrorAlertScreen(_ error: Swift.Error) {
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
        viewController.didPressSearch = { [weak self] fromDate, toDate in
            guard let self = self else { return }
            self.delegate.presentation(self, searchExpensesFrom: fromDate, toDate: toDate)
        }
        statisticScreen = viewController
        return viewController
    }
    
    public func showStatisticTotalSpent(_ spent: Decimal) {
        statisticScreen?.showResult(spent)
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
