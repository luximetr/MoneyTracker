//
//  AddExpenceScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

final class AddExpenseScreenViewController: StatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: Data
    
    private var dayExpenses: [Expense] = []
    private var accounts: [Account]
    private var categories: [Category]
    private var selectedCategory: Category?
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var addCategoryClosure: (() -> Void)?
    var addExpenseClosure: ((AddingExpense) throws -> Expense)?
    var editExpenseClosure: ((Expense) throws -> Expense)?
    var dayExpensesClosure: ((Date) throws -> [Expense])?
    var deleteExpenseClosure: ((Expense) throws -> Void)?

    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, accounts: [Account], categories: [Category], selectedCategory: Category?) {
        self.accounts = accounts
        self.categories = categories
        self.selectedCategory = selectedCategory ?? categories.first
        self.inputAmountViewController = InputAmountViewController()
        self.balanceAccountHorizontalPickerController = BalanceAccountHorizontalPickerController(locale: locale, appearance: appearance)
        self.selectCategoryViewController = CategoryVerticalPickerController(appearance: appearance, locale: locale)
        self.inputDateViewController = InputDateViewController(locale: locale)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let balanceAccountHorizontalPickerController: BalanceAccountHorizontalPickerController
    private let inputDateViewController: InputDateViewController
    private let commentTextFieldController = AUIEmptyTextFieldController()
    private let inputAmountViewController: InputAmountViewController
    private let selectCategoryViewController: CategoryVerticalPickerController
    private let expensesTableViewController = AUIEmptyTableViewController()
    private let expensesSectionController = AUIEmptyTableViewSectionController()
    private func expenseCellController(expense: Expense) -> ExpenseTableViewCellController? {
        let cellController = expensesSectionController.cellControllers.first { cellController in
            guard let expenseCellController = cellController as? ExpenseTableViewCellController else { return false }
            return expenseCellController.expense.id == expense.id
        }
        return cellController as? ExpenseTableViewCellController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setupInputDateViewController()
        setupCommentTextFieldController()
        inputAmountViewController.inputAmountView = screenView.inputAmountView
        inputAmountViewController.placeholder = "0"
        selectCategoryViewController.setCategories(categories)
        selectCategoryViewController.pickerView = screenView.selectCategoryView
        selectCategoryViewController.setSelectedCategory(selectedCategory)
        selectCategoryViewController.didTapOnAddClosure = { [weak self] in
            self?.addCategoryClosure?()
        }
        screenView.addButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceAccountHorizontalPickerController.balanceAccountHorizontalPickerView = screenView.selectAccountView
        balanceAccountHorizontalPickerController.showOptions(accounts: accounts)
        balanceAccountHorizontalPickerController.setSelectedAccount(accounts.first)
        balanceAccountHorizontalPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccount()
        }
        setupExpensesTableViewController()
        dayExpenses = (try? dayExpensesClosure?(Date())) ?? []
        setupErrorSnackbarViewController()
        setContent()
        setExpensesTableViewControllerContent()
        setDayExpensesContent()
    }
    
    private func setupTapGestureRecognizer() {
        screenView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerAction))
    }
    
    private func setupExpensesTableViewController() {
        expensesTableViewController.tableView = screenView.expensesTableView
    }
    
    private func setupInputDateViewController() {
        inputDateViewController.inputDateView = screenView.inputDateView
        inputDateViewController.didSelectDayClosure = { [weak self] day in
            guard let self = self else { return }
            self.selectDay(day)
        }
    }
    
    private func setupCommentTextFieldController() {
        commentTextFieldController.textField = screenView.commentTextField
        commentTextFieldController.returnKeyType = .done
        commentTextFieldController.addDidTapReturnKeyObserver(self)
    }
    
    // MARK: Events
    
    @objc private func tapGestureRecognizerAction() {
        view.endEditing(true)
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func selectDay(_ day: Date) {
        guard let dayExpensesClosure = dayExpensesClosure else { return }
        do {
            dayExpenses = try dayExpensesClosure(day)
            setExpensesTableViewControllerContent()
            setDayExpensesContent()
        } catch {
            
        }
    }
    
    @objc func editButtonTouchUpInsideEventAction() {
        let date = inputDateViewController.selectedDay
        guard let amount = inputAmountViewController.amount else {
            showErrorSnackbar(localizer.localizeText("invalidAmountErrorMessage"))
            return
        }
        guard let category = selectCategoryViewController.selectedCategory else {
            showErrorSnackbar(localizer.localizeText("emptyCategoryErrorMessage"))
            return
        }
        guard let account = balanceAccountHorizontalPickerController.selectedAccount else {
            showErrorSnackbar(localizer.localizeText("emptyAccountErrorMessage"))
            return
        }
        let comment = screenView.commentTextField.text
        if let editingExpense = self.editingExpense {
            do {
                let addingExpense = Expense(id: editingExpense.id, timestamp: editingExpense.timestamp, amount: amount, account: account, category: category, comment: comment)
                _ = try editExpenseClosure?(addingExpense)
                self.editExpense(addingExpense)
                self.selectExpense(nil)
            } catch {
                
            }
        } else {
            let addingExpense = AddingExpense(timestamp: date, amount: amount, account: account, category: category, comment: comment)
            guard let addExpenseClosure = addExpenseClosure else { return }
            do {
                let addedExpense = try addExpenseClosure(addingExpense)
                addExpense(addedExpense)
                inputAmountViewController.input = ""
                commentTextFieldController.text = nil
                view.endEditing(true)
            } catch {
                
            }
        }
    }
    
    private func addAccount() {
        addAccountClosure?()
    }
    
    func addExpense(_ expense: Expense) {
        dayExpenses.insert(expense, at: 0)
        setDayExpensesContent()
        let cellController = createExpenseTableViewController(expense: expense)
        expensesTableViewController.insertCellControllerAtSectionBeginningAnimated(expensesSectionController, cellController: cellController, .top, completion: nil)
    }
    
    func editExpense(_ expense: Expense) {
        guard let index = dayExpenses.firstIndex(where: { $0.id == expense.id }) else { return }
        dayExpenses[index] = expense
        setDayExpensesContent()
        let cellController = expenseCellController(expense: expense)
        cellController?.editExpense(expense)
    }
    
    func textFieldControllerDidTapReturnKey(_ textFieldController: AUITextFieldController) {
        view.endEditing(true)
    }
    
    func deleteExpense(_ deletingExpense: Expense) {
        if let index = dayExpenses.firstIndex(of: deletingExpense) {
            dayExpenses.remove(at: index)
            if let cellController = expenseCellController(expense: deletingExpense) {
                expensesTableViewController.deleteCellControllerAnimated(cellController, .left, completion: nil)
            }
        }
        setDayExpensesContent()
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        balanceAccountHorizontalPickerController.showOptions(accounts: accounts)
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        selectCategoryViewController.setCategories(categories)
        selectCategoryViewController.setSelectedCategory(category)
    }
    
    private var editingExpense: Expense?
    func selectExpense(_ expense: Expense?) {
        if let expense = expense {
            if expense.id == editingExpense?.id {
                editingExpense = nil
                let cellController = expenseCellController(expense: expense)
                cellController?.setIsSelected(false, animated: true)
                inputAmountViewController.input = ""
                commentTextFieldController.text = nil
            } else {
                if let editingExpense = self.editingExpense {
                    let cellController = expenseCellController(expense: editingExpense)
                    cellController?.setIsSelected(false, animated: true)
                }
                self.editingExpense = expense
                let cellController = expenseCellController(expense: expense)
                cellController?.setIsSelected(true, animated: true)
                
                inputAmountViewController.setAmount(expense.amount)
                commentTextFieldController.text = expense.comment
                balanceAccountHorizontalPickerController.setSelectedAccount(expense.account)
                selectCategoryViewController.setSelectedCategory(expense.category)
            }
        } else {
            if let editingExpense = self.editingExpense {
                let cellController = expenseCellController(expense: editingExpense)
                cellController?.setIsSelected(false, animated: true)
            }
            editingExpense = nil
            inputAmountViewController.input = ""
            commentTextFieldController.text = nil
        }
        
    }
    
    // MARK: Content

    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: locale.language, stringsTableName: "AddExpenseScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        let language = locale.language
        localizer.changeLanguage(language)
        selectCategoryViewController.changeLocale(locale)
        balanceAccountHorizontalPickerController.changeLocale(locale)
        inputDateViewController.changeLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        commentTextFieldController.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
    }
    
    private func setDayExpensesContent() {
        var currenciesAmounts: [Currency: Decimal] = [:]
        for expense in dayExpenses {
            let currency = expense.account.currency
            let amount = expense.amount
            let currencyAmount = (currenciesAmounts[currency] ?? .zero) + amount
            currenciesAmounts[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmounts.sorted(by: { $0.1 < $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let currencyAmountString = "\(amount) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        screenView.dayExpensesLabel.text = currenciesAmountsStringsJoined
    }
    
    private func setExpensesTableViewControllerContent() {
        expensesSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        for expense in dayExpenses {
            let cellController = createExpenseTableViewController(expense: expense)
            cellControllers.append(cellController)
        }
        expensesSectionController.cellControllers = cellControllers
        expensesTableViewController.sectionControllers = [expensesSectionController]
        expensesTableViewController.reload()
    }
    
    private func createExpenseTableViewController(expense: Expense) -> AUITableViewCellController {
        let cellController = ExpenseTableViewCellController(expense: expense)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.expenseTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.expenseTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.expenseTableViewCellHeight()
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self] contextualAction, view, success in
                guard let self = self else { return }
                guard let deleteExpenseClosure = self.deleteExpenseClosure else {
                    success(false)
                    return
                }
                do {
                    try deleteExpenseClosure(expense)
                    guard let index = self.dayExpenses.firstIndex(where: { expense == $0  }) else {
                        success(false)
                        return
                    }
                    self.dayExpenses.remove(at: index)
                    self.setDayExpensesContent()
                    self.expensesTableViewController.deleteCellControllerAnimated(cellController, .left) { finished in
                        success(true)
                    }
                } catch {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            let expense = cellController.expense
            self.selectExpense(expense)
        }
        return cellController
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        balanceAccountHorizontalPickerController.changeAppearance(appearance)
        selectCategoryViewController.changeAppearance(appearance)
    }
    
    // MARK: - Error Snackbar
    
    private let errorSnackbarViewController: ErrorSnackbarViewController
    
    private func setupErrorSnackbarViewController() {
        errorSnackbarViewController.errorSnackbarView = screenView.errorSnackbarView
    }
    
    private func showErrorSnackbar(_ message: String) {
        errorSnackbarViewController.showMessage(message)
    }
    
}
