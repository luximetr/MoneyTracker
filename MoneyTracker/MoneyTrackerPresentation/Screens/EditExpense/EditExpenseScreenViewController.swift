//
//  EditExpenseScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit

class EditExpenseScreenViewController: AUIStatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var editExpenseClosure: ((Expense) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "EditExpenseScreenStrings")
        return localizer
    }()
    
    // MARK: - Data
    
    private let expense: Expense
    private let categories: [Category]
    private let balanceAccounts: [Account]
    
    // MARK: - Life cycle
    
    init(expense: Expense, categories: [Category], balanceAccounts: [Account]) {
        self.expense = expense
        self.categories = categories
        self.balanceAccounts = balanceAccounts
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
        
    override func loadView() {
        view = ScreenView()
    }
    
    private let dayDatePickerViewController = AUIEmptyDateTimePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBalanceAccountPickerController()
        setupCategoryPickerController()
        setupCommentTextFieldController()
        setupAmountTextFieldController()
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        screenView.categoryPickerHeaderLabel.text = localizer.localizeText("categoryPickerHeader")
        screenView.amountInputView.placeholder = localizer.localizeText("amountPlaceholder")
        screenView.amountInputView.label.text = balanceAccountPickerController.selectedAccount?.currency.rawValue
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.saveButton.setTitle(localizer.localizeText("saveButtonTitle"), for: .normal)
        screenView.saveButton.addTarget(self, action: #selector(didTapOnSaveButton), for: .touchUpInside)
        screenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
        dayDatePickerViewController.datePicker = screenView.dayDatePickerView
        dayDatePickerViewController.mode = .date
    }
    
    // MARK: - View - Actions
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    // MARK: - Balance account picker
    
    private let balanceAccountPickerController = BalanceAccountHorizontalPickerController()
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = screenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: expense.account)
    }
    
    private var selectedBalanceAccount: Account? {
        return balanceAccountPickerController.selectedAccount
    }
    
    private func didSelectBalanceAccount(_ account: Account) {
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
    }
    
    // MARK: - Category picker
    
    private let categoryPickerController = CategoryHorizontalPickerController()
    
    private func setupCategoryPickerController() {
        categoryPickerController.categoryHorizontalPickerView = screenView.categoryPickerView
        categoryPickerController.showOptions(categories: categories, selectedCategory: expense.category)
    }
    
    private func nameTextFieldDidTapReturnKey() {
        view.endEditing(true)
    }
    
    // MARK: - Amount input
    
    private let amountInputController = TextFieldLabelController()
    
    private func setupAmountTextFieldController() {
        amountInputController.textFieldLabelView = screenView.amountInputView
        let textFieldController = amountInputController.textFieldController
        textFieldController.keyboardType = .decimalPad
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        textFieldController.text = numberFormatter.string(from: NSDecimalNumber(decimal: expense.amount))
    }
    
    // MARK: - Amount input - Currency
    
    private func showAmountInputCurrencyCode(_ currencyCode: String?) {
        screenView.amountInputView.label.text = currencyCode
        screenView.amountInputView.layoutSubviews()
    }
    
    // MARK: - Comment input
    
    private let commentTextFieldController = AUIEmptyTextFieldController()
    
    private func setupCommentTextFieldController() {
        commentTextFieldController.textField = screenView.commentTextField
        commentTextFieldController.keyboardType = .asciiCapable
        commentTextFieldController.returnKeyType = .done
        commentTextFieldController.addDidTapReturnKeyObserver(self)
        commentTextFieldController.text = expense.comment
    }
    
    // MARK: - Comment input - Return Key
    
    private func commentTextFieldDidTapReturnKey() {
        view.endEditing(true)
    }
    
    // MARK: - AUITextFieldControllerDidTapReturnKeyObserver
    
    func textFieldControllerDidTapReturnKey(_ textFieldController: AUITextFieldController) {
        if textFieldController === commentTextFieldController {
            commentTextFieldDidTapReturnKey()
        }
    }
    
    // MARK: - Save button
    
    @objc private func didTapOnSaveButton() {
        guard let selectedAccount = balanceAccountPickerController.selectedAccount else { return }
        guard let selectedCategory = categoryPickerController.selectedCategory else { return }
        guard let amount = getInputAmount() else { return }
        let comment = commentTextFieldController.text
        let expense = Expense(
            id: expense.id,
            amount: amount,
            date: dayDatePickerViewController.date,
            comment: comment,
            account: selectedAccount,
            category: selectedCategory
        )
        editExpenseClosure?(expense)
        backClosure?()
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
}
