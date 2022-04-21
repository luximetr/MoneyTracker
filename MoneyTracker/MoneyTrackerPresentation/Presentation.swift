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
    
    public init(window: UIWindow, appearanceSetting: AppearanceSetting) {
        self.appearanceSetting = appearanceSetting
        super.init(window: window)
        self.appearance = appearance(appearanceSetting)
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
    
    private func appearance(_ appearanceSetting: AppearanceSetting) -> Appearance {
        let appearance: Appearance
        switch appearanceSetting {
        case .light:
            appearance = LightAppearance()
        case .dark:
            appearance = DarkAppearance()
        case .system:
            let overrideUserInterfaceStyle = window.overrideUserInterfaceStyle
            switch overrideUserInterfaceStyle {
            case .light:
                appearance = LightAppearance()
            case .dark:
                appearance = DarkAppearance()
            case .unspecified:
                appearance = LightAppearance()
            @unknown default:
                appearance = LightAppearance()
            }
        }
        return appearance
    }
    
    private var appearanceSetting: AppearanceSetting
    private var appearance: Appearance = LightAppearance()
    
    private func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        menuScreenViewController?.changeAppearance(appearance)
        dashboardViewController?.changeAppearance(appearance)
        pushedAddExpenseViewController?.changeAppearance(appearance)
        statisticScreen?.changeAppearance(appearance)
        historyViewController?.changeAppearance(appearance)
        selectIconViewController?.changeAppearance(appearance)
        pushedCategoriesViewController?.changeAppearance(appearance)
        presentedAddCategoryViewController?.changeAppearance(appearance)
        pushedAddCategoryViewController?.changeAppearance(appearance)
        pushedEditCategoryViewController?.changeAppearance(appearance)
        pushedSelectAppearanceViewController?.changeAppearance(appearance)
        pushedAccoutsViewController?.changeAppearance(appearance)
        pushedAddAccoutScreenViewController?.changeAppearance(appearance)
        presentedAddAccoutScreenViewController?.changeAppearance(appearance)
        pushedEditAccoutScreenViewController?.changeAppearance(appearance)
        settingsScreenViewController?.changeAppearance(appearance)
        pushedTemplatesScreenViewController?.changeAppearance(appearance)
        pushedAddTemplateScreenViewController?.changeAppearance(appearance)
        presentedAddTemplateScreenViewController?.changeAppearance(appearance)
        pushedEditTemplateScreenViewController?.changeAppearance(appearance)
    }
    
    public func didChangeUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        guard appearanceSetting == .system else { return }
        let appearance = getAppearance(userInterfaceStyle: style)
        setAppearance(appearance)
    }
    
    private func getAppearance(userInterfaceStyle: UIUserInterfaceStyle) -> Appearance {
        switch userInterfaceStyle {
            case .dark: return DarkAppearance()
            default: return LightAppearance()
        }
    }
    
    // MARK: - Language
    
    func changeLanguage(_ language: Language) {
        menuScreenViewController?.changeLanguage(language)
        dashboardViewController?.changeLanguage(language)
        settingsScreenViewController?.changeLanguage(language)
    }
    
    // MARK: - Display
    
    public func display() {
        let language = try! delegate.presentationLanguage(self)
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
        let menuViewController = MenuScreenViewController(appearance: appearance, language: language, dashboardScreenViewController: dashboardNavigationController, historyScreenViewController: historyNavigationController, statisticScreenViewController: statisticNavigationController, settingsScreenViewController: settingsNavigationController)
        let menuNavigationController = AUINavigationBarHiddenNavigationController()
        menuNavigationController.viewControllers = [menuViewController]
        self.menuNavigationController = menuNavigationController
        self.menuScreenViewController = menuViewController
        window.rootViewController = menuNavigationController
        menuViewController.settings()
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
        let language = try! delegate.presentationLanguage(self)
        let viewController = DashboardScreenViewController(appearance: appearance, language: language, categories: categories, accounts: accounts, templates: templates)
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
    
    // MARK: - Add Expense View Controller
    
    private weak var pushedAddExpenseViewController: AddExpenseScreenViewController?
    private func pushAddExpenseViewController(_ navigationController: UINavigationController, selectedCategory: Category?) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let categories = try delegate.presentationCategories(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = AddExpenseScreenViewController(appearance: appearance, language: language, accounts: accounts, categories: categories, selectedCategory: selectedCategory)
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
    
    // MARK: - Transfer View Controller
    
    private weak var pushedAddTransferViewController: AddTransferScreenViewController?
    private func pushAddTransferViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = AddTransferScreenViewController(appearance: appearance, language: language, accounts: accounts)
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
    
    // MARK: - Top Up Account View Controller
    
    private weak var pushedTopUpAccountViewController: TopUpAccountScreenViewController?
    private func pushTopUpAccountViewController(_ navigationController: UINavigationController, selectedAccount: Account) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = TopUpAccountScreenViewController(appearance: appearance, language: language, accounts: accounts, selectedAccount: selectedAccount)
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
    
    // MARK: - ExpenseAddedSnackbarView
    
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
    
    // MARK: - History Navigation Controller
    
    private weak var historyNavigationController: UINavigationController?
    
    // MARK: - History View Controller
    
    private weak var historyViewController: HistoryScreenViewController?
    private func createHistoryViewController() -> HistoryScreenViewController {
        let expenses = (try? delegate.presentationExpenses(self)) ?? []
        let language = try! delegate.presentationLanguage(self)
        let viewController = HistoryScreenViewController(appearance: appearance, language: language, expenses: expenses)
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
    
    // MARK: - Edit Expense View Controller
    
    private weak var pushedEditExpenseViewController: EditExpenseScreenViewController?
    private func pushEditExpenseViewController(_ navigationController: UINavigationController, expense: Expense) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let categories = try delegate.presentationCategories(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = EditExpenseScreenViewController(appearance: appearance, language: language, expense: expense, categories: categories, balanceAccounts: accounts)
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
        let language = try! self.delegate.presentationLanguage(self)
        let viewController = StatisticScreenViewController(appearance: appearance, language: language)
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
    
    // MARK: - Settings Navigation Controller
    
    private weak var settingsNavigationController: UINavigationController?
    
    // MARK: - Categories View Controller
    
    private weak var pushedCategoriesViewController: CategoriesListScreenViewController?
    
    private func pushCategoriesListViewController(_ navigationController: UINavigationController) throws {
        do {
            let categories: [Category] = try delegate.presentationCategories(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = CategoriesListScreenViewController(appearance: appearance, language: language, categories: categories)
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
        do {
            let language = try delegate.presentationLanguage(self)
            let viewController = AddCategoryScreenViewController(appearance: appearance, language: language, categoryColors: CategoryColor.allCases, categoryIconName: CategoryIconNames.variant1)
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
        } catch {
            let error = Error("Cannot push AddCategoryScreenViewController\n\(error)")
            throw error
        }
    }
    
    private var presentedAddCategoryViewController: AddCategoryScreenViewController?
    private func presentAddCategoryScreenViewController(_ presentingViewController: UIViewController) throws {
        do {
            let language = try delegate.presentationLanguage(self)
            let viewController = AddCategoryScreenViewController(appearance: appearance, language: language, categoryColors: CategoryColor.allCases, categoryIconName: CategoryIconNames.variant1)
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
                    color: color,
                    onSelectIcon: { iconName in
                        viewController?.showCategoryIcon(iconName: iconName)
                    }
                )
                viewController?.present(selectIconViewController, animated: true)
            }
            presentedAddCategoryViewController = viewController
            presentingViewController.present(viewController, animated: true, completion: nil)
        } catch {
            let error = Error("Cannot present AddCategoryScreenViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Edit Category View Controller
    
    private weak var pushedEditCategoryViewController: EditCategoryScreenViewController?
    private func pushEditCategoryScreenViewController(_ navigationController: UINavigationController, category: Category) throws {
        do {
            let language = try delegate.presentationLanguage(self)
            let viewController = EditCategoryScreenViewController(appearance: appearance, language: language, category: category, categoryColors: CategoryColor.allCases)
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
        } catch {
            let error = Error("Cannot push EditCategoryScreenViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Select Icon View Controller
    
    private weak var selectIconViewController: SelectIconScreenViewController?
    private func createSelectIconViewController(
        color: CategoryColor,
        onSelectIcon: @escaping (String) -> Void
    ) -> SelectIconScreenViewController {
        let language = try! delegate.presentationLanguage(self)
        let viewController = SelectIconScreenViewController(appearance: appearance, language: language, iconNames: CategoryIconNames.variants, color: color)
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
        let language = (try? delegate.presentationLanguage(self)) ?? .english
        let defaultCurrency = try! delegate.presentationSelectedCurrency(self)
        let appearanceSetting = try! self.delegate.presentationAppearanceSetting(self)
        let viewController = SettingsScreenViewController(appearance: appearance, language: language, defaultCurrency: defaultCurrency, appearanceSetting: appearanceSetting)
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
            guard let settingsNavigationController = self.settingsNavigationController else { return }
            do {
                try self.pushSelectCurrencyViewController(settingsNavigationController, selectedCurrency: nil)
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
                let viewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                viewController.overrideUserInterfaceStyle = self.appearance.overrideUserInterfaceStyle
                self.menuNavigationController?.present(viewController, animated: true)
            } catch {
                self.presentUnexpectedErrorAlertScreen(error)
            }
        }
        return viewController
    }
    
    // MARK: - Select Currency View Controller
    
    private func presentSelectCurrencyViewController(_ presentingViewController: UIViewController, selectedCurrency: Currency?) throws {
        do {
            let currencies = delegate.presentationCurrencies(self)
            let selectedCurrency = try selectedCurrency ?? delegate.presentationSelectedCurrency(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = SelectCurrencyScreenViewController(appearance: appearance, language: language, currencies: currencies, selectedCurrency: selectedCurrency)
            viewController.backClosure = { [weak presentingViewController] in
                guard let presentingViewController = presentingViewController else { return }
                presentingViewController.dismiss(animated: true, completion: nil)
            }
            viewController.didSelectCurrencyClosure = { [weak self] currency in
                guard let self = self else { return }
                self.delegate.presentation(self, updateSelectedCurrency: currency)
                self.settingsScreenViewController?.changeDefaultCurrency(currency)
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
            let language = try delegate.presentationLanguage(self)
            let viewController = SelectCurrencyScreenViewController(appearance: appearance, language: language, currencies: currencies, selectedCurrency: selectedCurrency)
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
    
    // MARK: - Select Language View Controller
    
    private func pushSelectLanguageViewController(_ navigationController: UINavigationController, selectedLanguage: Language?) throws {
        do {
            let languages = try delegate.presentationLanguages(self)
            let selectedLanguage = try delegate.presentationLanguage(self)
            let viewController = SelectLanguageScreenViewController(appearance: appearance, languages: languages, selectedLanguage: selectedLanguage)
            viewController.backClosure = { [weak navigationController] in
                guard let navigationController = navigationController else { return }
                navigationController.popViewController(animated: true)
            }
            viewController.didSelectLanguageClosure = { [weak self] language in
                guard let self = self else { return }
                do {
                    try self.delegate.presentation(self, selectLanguage: language)
                    self.changeLanguage(language)
                } catch {
                    self.presentUnexpectedErrorAlertScreen(error)
                    throw error
                }
            }
            navigationController.pushViewController(viewController, animated: true)
        } catch {
            let error = Error("Cannot push SelectLanguageViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Select Appearance View Controller
    
    private weak var pushedSelectAppearanceViewController: SelectAppearanceScreenViewController?
    private func pushSelectAppearanceViewController(_ navigationController: UINavigationController) throws {
        do {
            let language = try delegate.presentationLanguage(self)
            let appearanceSetting = try self.delegate.presentationAppearanceSetting(self)
            let viewController = SelectAppearanceScreenViewController(appearance: appearance, language: language, appearanceSettings: [.light, .dark, .system], selectedAppearanceSetting: appearanceSetting)
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
        } catch {
            let error = Error("Cannot push SelectAppearanceViewController\n\(error)")
            throw error
        }
    }
    
    // MARK: - Accounts Screen View Controller
    
    private weak var pushedAccoutsViewController: AccountsScreenViewController?
    private func pushAccountsViewController(_ navigationController: UINavigationController) throws {
        do {
            let accounts = try delegate.presentationAccounts(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = AccountsScreenViewController(appearance: appearance, language: language, accounts: accounts)
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
    
    // MARK: - Add Accounts Screen View Controller
    
    private weak var pushedAddAccoutScreenViewController: AddAccountScreenViewController?
    private func pushAddAccountViewController(_ navigationController: UINavigationController) throws {
        do {
            let selectedCurrency = try delegate.presentationSelectedCurrency(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = AddAccountScreenViewController(appearance: appearance, language: language, accountColors: AccountColor.allCases, selectedCurrency: selectedCurrency)
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
            let selectedCurrency = try delegate.presentationSelectedCurrency(self)
            let language = try delegate.presentationLanguage(self)
            let viewController = AddAccountScreenViewController(appearance: appearance, language: language, accountColors: AccountColor.allCases, selectedCurrency: selectedCurrency)
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
    
    // MARK: - Edit Accounts Screen View Controller
    
    private weak var pushedEditAccoutScreenViewController: EditAccountScreenViewController?
    private func pushEditAccountViewController(_ navigationController: UINavigationController, editingAccount: Account) {
        let language = try! delegate.presentationLanguage(self)
        let viewController = EditAccountScreenViewController(appearance: appearance, language: language, editingAccount: editingAccount, accountColors: AccountColor.allCases)
        viewController.backClosure = { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        viewController.selectCurrencyClosure = { [weak self, weak navigationController] in
            guard let self = self else { return }
            guard let navigationController = navigationController else { return }
            let currencies = self.delegate.presentationCurrencies(self)
            let selectedCurrency = viewController.selectedCurrency
            let language = try! self.delegate.presentationLanguage(self)
            let selectCurrencyViewController = SelectCurrencyScreenViewController(appearance: self.appearance, language: language, currencies: currencies, selectedCurrency: selectedCurrency)
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
            let language = try delegate.presentationLanguage(self)
            let viewController = TemplatesScreenViewController(appearance: appearance, language: language, templates: templates)
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
            let language = try delegate.presentationLanguage(self)
            let viewController = AddTemplateScreenViewController(appearance: appearance, language: language, categories: categories, balanceAccounts: balanceAccounts)
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
            let language = try delegate.presentationLanguage(self)
            let viewController = AddTemplateScreenViewController(appearance: appearance, language: language, categories: categories, balanceAccounts: balanceAccounts)
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
            let language = try delegate.presentationLanguage(self)
            let viewController = EditTemplateScreenViewController(appearance: appearance, language: language, expenseTemplate: expenseTemplate, categories: categories, balanceAccounts: balanceAccounts)
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
        let language = try! delegate.presentationLanguage(self)
        viewController.language = language
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
        let language = try! delegate.presentationLanguage(self)
        let viewController = UnexpectedErrorDetailsScreenViewController(appearance: appearance, language: language, error: error)
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
