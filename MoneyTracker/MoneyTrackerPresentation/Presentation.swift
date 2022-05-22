//
//  Presentation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit
import MessageUI

public final class Presentation: AUIWindowPresentation {
        
    // MARK: Initializer
    
    public init(window: UIWindow, locale: Locale, appearanceSetting: AppearanceSetting) {
        self.locale = locale
        self.appearanceSetting = appearanceSetting
        self.appearance = Presentation.appearance(appearanceSetting, window: window)
        super.init(window: window)
    }
    
    // MARK: - Delegate
    
    public weak var delegate: PresentationDelegate!
    
    // MARK: - Appearance
    
    private func setAppearanceSetting(_ appearanceSetting: AppearanceSetting) {
        self.appearanceSetting = appearanceSetting
        let appearance: Appearance = appearance(appearanceSetting)
        setAppearance(appearance)
        settingsScreenViewController?.changeAppearanceSetting(appearanceSetting)
    }
    
    private static func appearance(_ appearanceSetting: AppearanceSetting, window: UIWindow) -> Appearance {
        switch appearanceSetting {
        case .light:
            return CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: LightAppearanceColors(), images: DefaultAppearanceImages())
        case .dark:
            return CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: DarkAppearanceColors(), images: DefaultAppearanceImages())
        case .system:
            let userInterfaceStyle = window.traitCollection.userInterfaceStyle
            switch userInterfaceStyle {
                case .dark: return CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: DarkAppearanceColors(), images: DefaultAppearanceImages())
                default: return CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: LightAppearanceColors(), images: DefaultAppearanceImages())
            }
        }
    }
    
    private func appearance(_ appearanceSetting: AppearanceSetting) -> Appearance {
        return Presentation.appearance(appearanceSetting, window: window)
    }
    
    private var appearanceSetting: AppearanceSetting
    private var appearance: Appearance
    
    private func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        menuScreenViewController?.changeAppearance(appearance)
        dashboardViewController?.changeAppearance(appearance)
        pushedAddExpenseViewController?.changeAppearance(appearance)
        statisticExpensesByCategoriesScreenViewController?.changeAppearance(appearance)
        pushedHistoryViewController?.changeAppearance(appearance)
        pushedEditExpenseViewController?.changeAppearance(appearance)
        selectIconViewController?.changeAppearance(appearance)
        pushedCategoriesViewController?.changeAppearance(appearance)
        presentedAddCategoryViewController?.changeAppearance(appearance)
        pushedAddCategoryViewController?.changeAppearance(appearance)
        pushedEditCategoryViewController?.changeAppearance(appearance)
        pushedAccoutsViewController?.changeAppearance(appearance)
        pushedAddAccoutScreenViewController?.changeAppearance(appearance)
        presentedAddAccoutScreenViewController?.changeAppearance(appearance)
        pushedEditAccoutScreenViewController?.changeAppearance(appearance)
        settingsScreenViewController?.changeAppearance(appearance)
        pushedSelectDefaultCurrencyViewController?.changeAppearance(appearance)
        presentedSelectCurrencyViewController?.changeAppearance(appearance)
        pushedSelectAppearanceViewController?.changeAppearance(appearance)
        pushedSelectLanguageViewController?.changeAppearance(appearance)
        pushedTemplatesScreenViewController?.changeAppearance(appearance)
        pushedAddTemplateScreenViewController?.changeAppearance(appearance)
        presentedAddTemplateScreenViewController?.changeAppearance(appearance)
        pushedEditTemplateScreenViewController?.changeAppearance(appearance)
        importCSVScreen?.changeAppearance(appearance)
        exportCSVScreen?.changeAppearance(appearance)
        expenseAddedSnackbarViewControllers.forEach { $0.changeAppearance(appearance) }
        pushedEditReplenishmentViewController?.changeAppearance(appearance)
        pushedAddReplenishmentViewController?.changeAppearance(appearance)
        pushedAddTransferViewController?.changeAppearance(appearance)
        pushedEditTransferViewController?.changeAppearance(appearance)
    }
    
    public func didChangeUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        guard appearanceSetting == .system else { return }
        let appearance = getAppearance(userInterfaceStyle: style)
        setAppearance(appearance)
    }
    
    private func getAppearance(userInterfaceStyle: UIUserInterfaceStyle) -> Appearance {
        switch userInterfaceStyle {
            case .dark: return CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: DarkAppearanceColors(), images: DefaultAppearanceImages())
            default: return CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: LightAppearanceColors(), images: DefaultAppearanceImages())
        }
    }
    
    // MARK: - Locale
    
    private var locale: Locale
    
    func changeLocale(_ locale: Locale) {
        self.locale = locale
        menuScreenViewController?.changeLocale(locale)
        dashboardViewController?.changeLocale(locale)
        settingsScreenViewController?.changeLocale(locale)
        statisticExpensesByCategoriesScreenViewController?.changeLocale(locale)
        pushedSelectLanguageViewController?.changeLocale(locale)
    }
    
    // MARK: - Display
    
    public func display() {
        // Dashboard
        let dashboardViewController = createDashboardViewController()
        let dashboardNavigationController = AUINavigationBarHiddenNavigationController()
        dashboardNavigationController.viewControllers = [dashboardViewController]
        self.dashboardViewController = dashboardViewController
        self.dashboardNavigationController = dashboardNavigationController
        // Statistic
        let statisticViewController = createStatisticMenuScreenViewController()
        let statisticNavigationController = AUINavigationBarHiddenNavigationController()
        statisticNavigationController.viewControllers = [statisticViewController]
        // Settings
        let settingsViewController = createSettingsScreenViewController()
        let settingsNavigationController = AUINavigationBarHiddenNavigationController()
        settingsNavigationController.viewControllers = [settingsViewController]
        self.settingsScreenViewController = settingsViewController
        self.settingsNavigationController = settingsNavigationController
        // Menu
        let menuViewController = MenuScreenViewController(appearance: appearance, locale: locale, dashboardScreenViewController: dashboardNavigationController, statisticScreenViewController: statisticNavigationController, settingsScreenViewController: settingsNavigationController)
        let menuNavigationController = AUINavigationBarHiddenNavigationController()
        menuNavigationController.viewControllers = [menuViewController]
        self.menuNavigationController = menuNavigationController
        self.menuScreenViewController = menuViewController
        window.rootViewController = menuNavigationController
        menuViewController.dashboard()
    }
    
    // MARK: - Menu Navigation Controller
    
    private weak var menuNavigationController: UINavigationController?
    
    // MARK: - Menu View Controller
    
    private weak var menuScreenViewController: MenuScreenViewController?
    
    // MARK: Dashboard Navigation Controller
    
    private weak var dashboardNavigationController: UINavigationController?
    
    // MARK: - Dashboard View Controller
    
    private weak var dashboardViewController: DashboardScreenViewController?
    private func createDashboardViewController() -> DashboardScreenViewController {
        let categories = (try? delegate.presentationCategories(self)) ?? []
        let accounts = (try? delegate.presentationAccounts(self)) ?? []
        let templates = (try? delegate.presentationExpenseTemplates(self)) ?? []
        let viewController = DashboardScreenViewController(appearance: appearance, locale: locale, categories: categories, accounts: accounts, templates: templates)
        viewController.historyClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushHistoryViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
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
            do {
                try self.presentAddCategoryScreenViewController(viewController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
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
                try self.pushAddReplenishmentViewController(menuNavigationController, selectedAccount: account)
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
                self.statisticExpensesByCategoriesScreenViewController?.addExpense(addedExpense)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        return viewController
    }
    
    // MARK: - Add Expense View Controller
    
    private weak var pushedAddExpenseViewController: AddExpenseScreenViewController?
    private func pushAddExpenseViewController(_ navigationController: UINavigationController, selectedCategory: Category?) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let categories = try delegate.presentationCategories(self)
            let viewController = AddExpenseScreenViewController(appearance: appearance, locale: locale, accounts: accounts, categories: categories, selectedCategory: selectedCategory)
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
                    self.statisticExpensesByCategoriesScreenViewController?.addExpense(addedExpense)
                    return addedExpense
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                    throw error
                }
            }
            viewController.editExpenseClosure = { [weak self] editingExpense in
                guard let self = self else { throw Error("") }
                do {
                    let addedExpense = try self.delegate.presentation(self, editExpense: editingExpense)
                    self.statisticExpensesByCategoriesScreenViewController?.editExpense(addedExpense)
                    return addedExpense
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                    throw error
                }
                
            }
            viewController.deleteExpenseClosure = { [weak self] expense in
                guard let self = self else { return }
                do {
                    _ = try self.delegate.presentation(self, deleteExpense: expense)
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
            viewController.addCategoryClosure = { [weak self, weak viewController] in
                guard let viewController = viewController else { return }
                do {
                    try self?.presentAddCategoryScreenViewController(viewController)
                } catch {
                    self?.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedAddExpenseViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push AddExpenseViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Transfer View Controller
    
    private weak var pushedAddTransferViewController: AddTransferScreenViewController?
    private func pushAddTransferViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            
            let viewController = AddTransferScreenViewController(appearance: appearance, locale: locale, accounts: accounts)
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
            viewController.addTransferClosure = { [weak self, weak navigationController] addingTransfer in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    _ = try self.delegate.presentation(self, addTransfer: addingTransfer)
                    navigationController.popViewController(animated: true)
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
    
    // MARK: - Top Up Account View Controller
    
    private weak var pushedAddReplenishmentViewController: AddReplenishmentScreenViewController?
    private func pushAddReplenishmentViewController(_ navigationController: UINavigationController, selectedAccount: Account) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            
            let viewController = AddReplenishmentScreenViewController(appearance: appearance, locale: locale, accounts: accounts, selectedAccount: selectedAccount)
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
            viewController.addReplenishmentClosure = { [weak self, weak navigationController] addingTopUpAccount in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    _ = try self.delegate.presentation(self, addTopUpAccount: addingTopUpAccount)
                    navigationController.popViewController(animated: true)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedAddReplenishmentViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push TopUpAccountViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - ExpenseAddedSnackbarView
    
    private var expenseAddedSnackbarViewControllers: [ExpenseAddedSnackbarViewController] = []
    private func displayExpenseAddedSnackbarViewController(template: ExpenseTemplate, expense: Expense) {
        let viewController = ExpenseAddedSnackbarViewController(appearance: appearance, locale: locale, template: template, expense: expense)
        let view = ExpenseAddedSnackbarView(appearance: appearance)
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
    
    // MARK: - History View Controller
    
    private weak var pushedHistoryViewController: HistoryScreenViewController?
    private func pushHistoryViewController(_ navigationController: UINavigationController) throws {
        do {
            let operations = try delegate.presentationOperations(self)
            
            let viewController = HistoryScreenViewController(appearance: appearance, locale: locale, operations: operations)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.deleteExpenseClosure = { [weak self] deletingExpense in
                guard let self = self else { return }
                do {
                    let deletedExpense = try self.delegate.presentation(self, deleteExpense: deletingExpense)
                    self.statisticExpensesByCategoriesScreenViewController?.deleteExpense(deletedExpense)
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
            viewController.deleteTransferClosure = { [weak self] deletingTransfer in
                guard let self = self else { return }
                do {
                    _ = try self.delegate.presentation(self, deleteBalanceTransfer: deletingTransfer)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.selectTransferClosure = { [weak self] transfer in
                guard let self = self else { return }
                guard let menuNavigationController = self.menuNavigationController else { return }
                do {
                    try self.pushEditTransferViewController(menuNavigationController, transfer: transfer)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.deleteBalanceReplenishmentClosure = { [weak self] deletingBalanceReplenishment in
                guard let self = self else { return }
                do {
                    _ = try self.delegate.presentation(self, deleteBalanceReplenishment: deletingBalanceReplenishment)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.selectReplenishmentClosure = { [weak self] replenishment in
                guard let self = self else { return }
                guard let menuNavigationController = self.menuNavigationController else { return }
                do {
                    try self.pushEditReplenishmentViewController(menuNavigationController, replenishment: replenishment)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            self.pushedHistoryViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push HistoryViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Edit Expense View Controller
    
    private weak var pushedEditExpenseViewController: EditExpenseScreenViewController?
    private func pushEditExpenseViewController(_ navigationController: UINavigationController, expense: Expense) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let categories = try delegate.presentationCategories(self)
            
            let viewController = EditExpenseScreenViewController(appearance: appearance, locale: locale, expense: expense, categories: categories, balanceAccounts: accounts)
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
                do {
                    try self.presentAddCategoryScreenViewController(viewController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            viewController.editExpenseClosure = { [weak self] expense in
                guard let self = self else { return }
                do {
                    let editedExpense = try self.delegate.presentation(self, editExpense: expense)
                    self.pushedHistoryViewController?.editExpense(editedExpense)
                    self.statisticExpensesByCategoriesScreenViewController?.editExpense(editedExpense)
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
    
    // MARK: - Edit Replenishment View Controller
    
    private weak var pushedEditReplenishmentViewController: EditReplenishmentScreenViewController?
    private func pushEditReplenishmentViewController(_ navigationController: UINavigationController, replenishment: Replenishment) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            
            let viewController = EditReplenishmentScreenViewController(appearance: appearance, locale: locale, replenishment: replenishment, accounts: accounts)
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
            viewController.editReplenishmentClosure = { [weak self, weak navigationController] editingReplenishment in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    let editedReplenishment = try self.delegate.presentation(self, editReplenishment: editingReplenishment)
                    self.pushedHistoryViewController?.editReplenishment(editedReplenishment)
                    navigationController.popViewController(animated: true)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedEditReplenishmentViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push TopUpAccountViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Edit Transfer View Controller
    
    private weak var pushedEditTransferViewController: EditTransferScreenViewController?
    private func pushEditTransferViewController(_ navigationController: UINavigationController, transfer: Transfer) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            
            let viewController = EditTransferScreenViewController(appearance: appearance, locale: locale, accounts: accounts, transfer: transfer)
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
            viewController.editTransferClosure = { [weak self, weak navigationController] editingTransfer in
                guard let self = self else { return }
                guard let navigationController = navigationController else { return }
                do {
                    let editedTransfer = try self.delegate.presentation(self, editTransfer: editingTransfer)
                    self.pushedHistoryViewController?.editTransfer(editedTransfer)
                    navigationController.popViewController(animated: true)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedEditTransferViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            throw Error("Cannot push EditTransferScreenViewController\n\(error)")
        }
    }
    
    // MARK: - StatisticMenuScreenViewController
    
    private weak var statisticMenuScreenViewController: StatisticMenuScreenViewController?
    private func createStatisticMenuScreenViewController() -> StatisticMenuScreenViewController {
        let viewController = StatisticMenuScreenViewController(appearance: appearance, locale: locale)
        
        viewController.didSelectExpensesByCategoriesClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushStatisticExpensesByCategoriesScreenViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.didSelectBalancesCalculatorClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushBalanceCalculatorScreenViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        self.statisticMenuScreenViewController = viewController
        return viewController
    }
    
    // MARK: - Statistic Screen
    
    private weak var statisticExpensesByCategoriesScreenViewController: StatisticExpensesByCategoriesScreenViewController?
    private func pushStatisticExpensesByCategoriesScreenViewController(_ navigationController: UINavigationController) throws {
        let viewController = StatisticExpensesByCategoriesScreenViewController(appearance: appearance, locale: locale)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
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
        statisticExpensesByCategoriesScreenViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - BalanceCalculatorScreenViewController
    
    private weak var balanceCalculatorScreenViewController: BalanceCalculatorScreenViewController?
    private func pushBalanceCalculatorScreenViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let viewController = BalanceCalculatorScreenViewController(appearance: appearance, locale: locale, accounts: accounts)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            balanceCalculatorScreenViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            throw Error("Cannot push BalanceCalculatorScreenViewController\n\(error)")
        }
    }
    
    // MARK: - Settings Navigation Controller
    
    private weak var settingsNavigationController: UINavigationController?
    
    // MARK: - Categories View Controller
    
    private weak var pushedCategoriesViewController: CategoriesListScreenViewController?
    
    private func pushCategoriesListViewController(_ navigationController: UINavigationController) throws {
        do {
            let categories: [Category] = try delegate.presentationCategories(self)
            
            let viewController = CategoriesListScreenViewController(appearance: appearance, locale: locale, categories: categories)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.editCategoryClosure = { [weak self] category in
                guard let self = self else { return }
                guard let menuNavigationController = self.menuNavigationController else { return }
                do {
                    try self.pushEditCategoryScreenViewController(menuNavigationController, category: category)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
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
                do {
                    try self.pushAddCategoryScreenViewController(navigationController)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                }
            }
            pushedCategoriesViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push CategoriesViewController\n\(error)")
            throw error
        }
        
    }
    
    // MARK: - Add Category View Controller
    
    private var pushedAddCategoryViewController: AddCategoryScreenViewController?
    private func pushAddCategoryScreenViewController(_ navigationController: UINavigationController) throws {
        let viewController = AddCategoryScreenViewController(appearance: appearance, locale: locale, categoryColors: CategoryColor.allCases, categoryIconName: CategoryIconNames.variant1)
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
                color: color,
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
    private func presentAddCategoryScreenViewController(_ presentingViewController: UIViewController) throws {
        let viewController = AddCategoryScreenViewController(appearance: appearance, locale: locale, categoryColors: CategoryColor.allCases, categoryIconName: CategoryIconNames.variant1)
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
                self.pushedAddExpenseViewController?.addCategory(addedCategory)
                viewController.dismiss(animated: true, completion: nil)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.selectIconClosure = { [weak self, weak viewController] color in
            guard let self = self else { return }
            let selectIconViewController = self.createSelectIconViewController(
                color: color,
                onSelectIcon: { iconName in
                    viewController?.showCategoryIcon(iconName: iconName)
                }
            )
            viewController?.present(selectIconViewController, animated: true)
        }
        presentedAddCategoryViewController = viewController
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Edit Category View Controller
    
    private weak var pushedEditCategoryViewController: EditCategoryScreenViewController?
    private func pushEditCategoryScreenViewController(_ navigationController: UINavigationController, category: Category) throws {
        let viewController = EditCategoryScreenViewController(appearance: appearance, locale: locale, category: category, categoryColors: CategoryColor.allCases)
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
                color: color,
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
    
    private weak var selectIconViewController: SelectIconScreenViewController?
    private func createSelectIconViewController(
        color: CategoryColor,
        onSelectIcon: @escaping (String) -> Void
    ) -> SelectIconScreenViewController {
        let viewController = SelectIconScreenViewController(appearance: appearance, locale: locale, iconNames: CategoryIconNames.variants, color: color)
        viewController.didSelectIconClosure = { [weak viewController] iconName in
            onSelectIcon(iconName)
            viewController?.dismiss(animated: true)
        }
        selectIconViewController = viewController
        return viewController
    }
    
    // MARK: - Settings Screen View Controller
    
    private weak var settingsScreenViewController: SettingsScreenViewController?
    private func createSettingsScreenViewController() -> SettingsScreenViewController {
        let defaultCurrency = try! delegate.presentationSelectedCurrency(self)
        let viewController = SettingsScreenViewController(appearance: appearance, locale: locale, defaultCurrency: defaultCurrency, appearanceSetting: self.appearanceSetting)
        viewController.didSelectCategoriesClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushCategoriesListViewController(menuNavigationController)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.didSelectCurrencyClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushSelectDefaultCurrencyViewController(menuNavigationController, selectedCurrency: nil)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.didSelectLanguageClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushSelectLanguageViewController(menuNavigationController, selectedLanguage: nil)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        viewController.didSelectAppearanceClosure = { [weak self] in
            guard let self = self else { return }
            guard let menuNavigationController = self.menuNavigationController else { return }
            do {
                try self.pushSelectAppearanceViewController(menuNavigationController)
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
                let viewController = self.createExportCSVScreen(url: url)
                self.menuNavigationController?.present(viewController, animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: - Currency
    
    public func showDefaultCurrencyChanged(_ currency: Currency) {
        settingsScreenViewController?.changeDefaultCurrency(currency)
    }
    
    // MARK: - Select Currency View Controller
    
    private weak var presentedSelectCurrencyViewController: SelectCurrencyScreenViewController?
    
    private func presentSelectCurrencyViewController(_ presentingViewController: UIViewController, selectedCurrency: Currency?, didSelectCurrency: ((Currency) -> Void)?) throws {
        do {
            let currencies = delegate.presentationCurrencies(self)
            let selectedCurrency = try selectedCurrency ?? delegate.presentationSelectedCurrency(self)
            
            let viewController = SelectCurrencyScreenViewController(appearance: appearance, locale: locale, currencies: currencies, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak presentingViewController] in
                guard let presentingViewController = presentingViewController else { return }
                presentingViewController.dismiss(animated: true, completion: nil)
            }
            viewController.didSelectCurrencyClosure = { [weak viewController] currency in
                viewController?.dismiss(animated: true)
                didSelectCurrency?(currency)
            }
            presentedSelectCurrencyViewController = viewController
            presentingViewController.present(viewController, animated: true, completion: nil)
        } catch {
            let error = Error("Cannot present SelectCurrencyViewController\n\(error)")
            throw error
        }
    }
    
    private weak var pushedSelectDefaultCurrencyViewController: SelectCurrencyScreenViewController?
    
    private func pushSelectDefaultCurrencyViewController(_ navigationController: UINavigationController, selectedCurrency: Currency?) throws {
        do {
            let currencies = delegate.presentationCurrencies(self)
            let selectedCurrency = try selectedCurrency ?? delegate.presentationSelectedCurrency(self)
            
            let viewController = SelectCurrencyScreenViewController(appearance: appearance, locale: locale, currencies: currencies, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.didSelectCurrencyClosure = { [weak self] currency in
                guard let self = self else { return }
                self.delegate.presentation(self, updateSelectedCurrency: currency)
                self.showDefaultCurrencyChanged(currency)
            }
            pushedSelectDefaultCurrencyViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push SelectCurrencyViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Select Language View Controller
    
    private weak var pushedSelectLanguageViewController: SelectLanguageScreenViewController?
    private func pushSelectLanguageViewController(_ navigationController: UINavigationController, selectedLanguage: Language?) throws {
        do {
            let languages = try delegate.presentationLanguages(self)
            let viewController = SelectLanguageScreenViewController(appearance: appearance, languages: languages, locale: locale)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.didSelectLanguageClosure = { [weak self] language in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, selectLanguage: language)
                    let locale = Locale(language: language, scriptCode: self.locale.scriptCode, regionCode: self.locale.regionCode)
                    self.changeLocale(locale)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                    throw error
                }
            }
            pushedSelectLanguageViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push SelectLanguageViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Select Appearance View Controller
    
    private weak var pushedSelectAppearanceViewController: SelectAppearanceScreenViewController?
    private func pushSelectAppearanceViewController(_ navigationController: UINavigationController) throws {
        let viewController = SelectAppearanceScreenViewController(appearance: appearance, locale: locale, appearanceSettings: [.light, .dark, .system], selectedAppearanceSetting: self.appearanceSetting)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.didSelectAppearanceSettingClosure = { [weak self] appearanceSetting in
            guard let self = self else { return }
            do {
                try self.delegate.presentation(self, selectAppearanceSetting: appearanceSetting)
                self.setAppearanceSetting(appearanceSetting)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
                throw error
            }
        }
        self.pushedSelectAppearanceViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Accounts Screen View Controller
    
    private weak var pushedAccoutsViewController: AccountsScreenViewController?
    private func pushAccountsViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            
            let viewController = AccountsScreenViewController(appearance: appearance, locale: locale, accounts: accounts)
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
            throw Error("Cannot push AccoutsViewController\n\(error)")
        }
    }
    
    // MARK: - Add Accounts Screen View Controller
    
    private weak var pushedAddAccoutScreenViewController: AddAccountScreenViewController?
    private func pushAddAccountViewController(_ navigationController: UINavigationController) throws {
        do {
            let selectedCurrency = try delegate.presentationSelectedCurrency(self)
            
            let viewController = AddAccountScreenViewController(appearance: appearance, locale: locale, accountColors: AccountColor.allCases, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.selectCurrencyClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    let selectedCurrency = viewController.selectedCurrency
                    try self.presentSelectCurrencyViewController(viewController, selectedCurrency: selectedCurrency, didSelectCurrency: { newSelectedCurrency in
                        viewController.setSelectedCurrency(newSelectedCurrency, animated: true)
                    })
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
                    self.pushedAddReplenishmentViewController?.addAccount(addedAccount)
                    self.pushedAddTemplateScreenViewController?.addAccount(addedAccount)
                    self.pushedEditReplenishmentViewController?.addAccount(addedAccount)
                    self.pushedEditTransferViewController?.addAccount(addedAccount)
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
            let selectedCurrency = try delegate.presentationSelectedCurrency(self)
            
            let viewController = AddAccountScreenViewController(appearance: appearance, locale: locale, accountColors: AccountColor.allCases, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak self] in
                guard let self = self else { return }
                self.menuNavigationController?.dismiss(animated: true, completion: nil)
            }
            viewController.selectCurrencyClosure = { [weak self, weak viewController] in
                guard let self = self else { return }
                guard let viewController = viewController else { return }
                do {
                    let selectedCurrency = viewController.selectedCurrency
                    try self.presentSelectCurrencyViewController(viewController, selectedCurrency: selectedCurrency, didSelectCurrency: { newSelectedCurrency in
                        viewController.setSelectedCurrency(newSelectedCurrency, animated: true)
                    })
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
                    self.pushedAddReplenishmentViewController?.addAccount(addedAccount)
                    self.pushedAddTemplateScreenViewController?.addAccount(addedAccount)
                    self.pushedEditReplenishmentViewController?.addAccount(addedAccount)
                    self.pushedEditTransferViewController?.addAccount(addedAccount)
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
    
    // MARK: - Edit Accounts Screen View Controller
    
    private weak var pushedEditAccoutScreenViewController: EditAccountScreenViewController?
    private func pushEditAccountViewController(_ navigationController: UINavigationController, editingAccount: Account) {
        let viewController = EditAccountScreenViewController(appearance: appearance, locale: locale, account: editingAccount, accountColors: AccountColor.allCases)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.selectCurrencyClosure = { [weak self, weak navigationController] in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            let currencies = self.delegate.presentationCurrencies(self)
            let selectedCurrency = viewController.selectedCurrency
            let selectCurrencyViewController = SelectCurrencyScreenViewController(appearance: self.appearance, locale: self.locale, currencies: currencies, selectedCurrency: selectedCurrency)
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
            
            let viewController = TemplatesScreenViewController(appearance: appearance, locale: locale, templates: templates)
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
            
            let viewController = AddTemplateScreenViewController(appearance: appearance, locale: locale, categories: categories, balanceAccounts: balanceAccounts)
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
                do {
                    try self.presentAddCategoryScreenViewController(viewController)
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
            
            let viewController = AddTemplateScreenViewController(appearance: appearance, locale: locale, categories: categories, balanceAccounts: balanceAccounts)
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
                do {
                    try self.presentAddCategoryScreenViewController(viewController)
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
            
            let viewController = EditTemplateScreenViewController(appearance: appearance, locale: locale, expenseTemplate: expenseTemplate, categories: categories, balanceAccounts: balanceAccounts)
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
                do {
                    try self.presentAddCategoryScreenViewController(viewController)
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
            pushedEditTemplateScreenViewController = viewController
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push EditTemplateScreenViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Import CSV Screen
    
    private weak var importCSVScreen: ImportCSVScreenViewController?
    private func createImportCSVScreen() -> UIDocumentPickerViewController {
        let controller = ImportCSVScreenViewController(appearance: appearance)
        controller.didPickDocument = { [weak self] url in
            guard let self = self else { return }
            do {
                try self.delegate.presentation(self, didPickDocumentAt: url)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        importCSVScreen = controller
        return controller
    }
    
    public func showDidImportExpensesFile(_ file: ImportedExpensesFile) {
        dashboardViewController?.addAccounts(file.importedAccounts)
        dashboardViewController?.addCategories(file.importedCategories)
    }
    
    // MARK: - Export CSV Screen
    
    private weak var exportCSVScreen: ExportCSVScreenViewController?
    
    private func createExportCSVScreen(url: URL) -> ExportCSVScreenViewController {
        let viewController = ExportCSVScreenViewController(appearance: appearance, activityItems: [url])
        exportCSVScreen = viewController
        return viewController
    }
    
    // MARK: - Unexpected Error Alert Screen
    
    private weak var unexpectedErrorAlertScreenViewController: UnexpectedErrorAlertScreenViewController?
    private func presentUnexpectedErrorAlertScreen(_ error: Swift.Error) {
        let viewController = UnexpectedErrorAlertScreenViewController(title: nil, message: nil, preferredStyle: .alert)
        viewController.locale = locale
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
    
    // MARK: - Unexpected Error Details Screen
    
    private weak var unexpectedErrorDetailsScreenViewController: UnexpectedErrorDetailsScreenViewController?
    private func displayUnexpectedErrorDetailsScreen(_ error: Swift.Error) {
        let viewController = UnexpectedErrorDetailsScreenViewController(appearance: appearance, locale: locale, error: error)
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
