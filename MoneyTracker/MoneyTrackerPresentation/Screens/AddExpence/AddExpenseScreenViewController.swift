//
//  AddExpenceScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

final class AddExpenseScreenViewController: AUIStatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: Data
    
    private var expenses: [Expense] = []
    private let accounts: [Account]
    private let categories: [Category]
    
    // MARK: Delegation
    
    var addExpenseClosure: ((AddingExpense) -> Void)?
    var dayExpensesClosure: ((Date) -> [Expense])?
    
    // MARK: Initializer
    
    init(accounts: [Account], categories: [Category]) {
        self.accounts = accounts
        self.categories = categories
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddExpenseScreenStrings")
        return localizer
    }()
    
    // MARK: View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView()
    }
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let balanceAccountHorizontalPickerController = BalanceAccountHorizontalPickerController()
    private let inputDateViewController = InputDateViewController()
    private let commentTextFieldController = AUIEmptyTextFieldController()
    private let inputAmountViewController = InputAmountViewController()
    private let selectCategoryViewController = SelectCategoryViewController()
    private let expensesTableViewController = AUIEmptyTableViewController()
    private let expensesSectionController = AUIEmptyTableViewSectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setupInputDateViewController()
        setupCommentTextFieldController()
        inputAmountViewController.inputAmountView = screenView.inputAmountView
        selectCategoryViewController.categories = categories
        selectCategoryViewController.selectCategoryView = screenView.selectCategoryView
        screenView.addButton.setTitle("✓", for: .normal)
        screenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceAccountHorizontalPickerController.balanceAccountHorizontalPickerView = screenView.selectAccountView
        if let firstAccount = accounts.first {
            balanceAccountHorizontalPickerController.showOptions(accounts: accounts, selectedAccount: firstAccount)
        }
        setupExpensesTableViewController()
        expenses = dayExpensesClosure?(Date()) ?? []
        setContent()
        setExpensesTableViewControllerContent()
    }
    
    private func setupTapGestureRecognizer() {
        screenView.addGestureRecognizer(tapGestureRecognizer)
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
    
    private func selectDay(_ day: Date) {
        expenses = dayExpensesClosure?(day) ?? []
        setExpensesTableViewControllerContent()
    }
    
    @objc func addButtonTouchUpInsideEventAction() {
        let date = inputDateViewController.datePickerController.date
        guard let amount = inputAmountViewController.amount else { return }
        guard let category = selectCategoryViewController.selectedCategory else { return }
        guard let account = balanceAccountHorizontalPickerController.selectedAccount else { return }
        let comment = screenView.commentTextField.text
        let addingExpense = AddingExpense(amount: amount, date: date, comment: comment, account: account, category: category)
        addExpenseClosure?(addingExpense)
        inputAmountViewController.input = ""
        view.endEditing(true)
    }
    
    func addExpense(_ expense: Expense) {
        expenses.insert(expense, at: 0)
        let cellController = createExpenseTableViewController(expense: expense)
        expensesTableViewController.insertCellControllerAtSectionBeginningAnimated(expensesSectionController, cellController: cellController, .top, completion: nil)
    }
    
    func textFieldControllerDidTapReturnKey(_ textFieldController: AUITextFieldController) {
        view.endEditing(true)
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        commentTextFieldController.placeholder = localizer.localizeText("commentPlaceholder")
    }
    
    private func setExpensesTableViewControllerContent() {
        expensesSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        for expense in expenses {
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
        return cellController
    }
    
}
