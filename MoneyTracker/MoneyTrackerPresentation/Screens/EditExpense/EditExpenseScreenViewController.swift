//
//  EditExpenseScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit

class EditExpenseScreenViewController: StatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: - Data
    
    private let expense: Expense
    private var categories: [Category]
    private var balanceAccounts: [Account]
    var backClosure: (() -> Void)?
    var addCategoryClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var editExpenseClosure: ((Expense) -> Void)?
    
    func addAccount(_ account: Account) {
        balanceAccounts.append(account)
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: account)
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        categoryPickerController.showOptions(categories: categories, selectedCategory: category)
    }
    
    // MARK: - Life cycle
    
    init(appearance: Appearance, language: Language, expense: Expense, categories: [Category], balanceAccounts: [Account]) {
        self.expense = expense
        self.categories = categories
        self.balanceAccounts = balanceAccounts
        self.balanceAccountPickerController = BalanceAccountHorizontalPickerController(language: language, appearance: appearance)
        self.categoryPickerController = CategoryHorizontalPickerController(language: language, appearance: appearance)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
        
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private let balanceAccountPickerController: BalanceAccountHorizontalPickerController
    private let categoryPickerController: CategoryHorizontalPickerController
    private let dayDatePickerViewController = AUIEmptyDateTimePickerController()
    private let amountInputController = TextFieldLabelController()
    private let commentTextFieldController = AUIEmptyTextFieldController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBalanceAccountPickerController()
        setupCategoryPickerController()
        setupCommentTextFieldController()
        setupAmountTextFieldController()
        screenView.amountInputView.label.text = balanceAccountPickerController.selectedAccount?.currency.rawValue
        screenView.saveButton.addTarget(self, action: #selector(didTapOnSaveButton), for: .touchUpInside)
        screenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
        dayDatePickerViewController.datePicker = screenView.dayDatePickerView
        dayDatePickerViewController.mode = .date
        dayDatePickerViewController.setDate(expense.date, animated: false)
        setContent()
    }
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = screenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        balanceAccountPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccount()
        }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: expense.account)
    }
    
    private func setupCategoryPickerController() {
        categoryPickerController.categoryHorizontalPickerView = screenView.categoryPickerView
        categoryPickerController.showOptions(categories: categories, selectedCategory: expense.category)
        categoryPickerController.addCategoryClosure = { [weak self] in
            guard let self = self else { return }
            self.addCategory()
        }
    }
    
    private func setupAmountTextFieldController() {
        amountInputController.textFieldLabelView = screenView.amountInputView
        let textFieldController = amountInputController.textFieldController
        textFieldController.keyboardType = .decimalPad
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        textFieldController.text = numberFormatter.string(from: NSDecimalNumber(decimal: expense.amount))
    }
    
    private func setupCommentTextFieldController() {
        commentTextFieldController.textField = screenView.commentTextField
        commentTextFieldController.keyboardType = .asciiCapable
        commentTextFieldController.returnKeyType = .done
        commentTextFieldController.addDidTapReturnKeyObserver(self)
        commentTextFieldController.text = expense.comment
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "EditExpenseScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        balanceAccountPickerController.changeLanguage(language)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        screenView.categoryPickerHeaderLabel.text = localizer.localizeText("categoryPickerHeader")
        screenView.amountInputView.placeholder = localizer.localizeText("amountPlaceholder")
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.saveButton.setTitle(localizer.localizeText("saveButtonTitle"), for: .normal)
    }
    
    // MARK: Events
    
    private func addAccount() {
        addAccountClosure?()
    }
    
    private func addCategory() {
        addCategoryClosure?()
    }
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    // MARK: - Balance account picker
    
    private var selectedBalanceAccount: Account? {
        return balanceAccountPickerController.selectedAccount
    }
    
    private func didSelectBalanceAccount(_ account: Account) {
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
    }
    
    private func nameTextFieldDidTapReturnKey() {
        view.endEditing(true)
    }
    
    // MARK: - Amount input - Currency
    
    private func showAmountInputCurrencyCode(_ currencyCode: String?) {
        screenView.amountInputView.label.text = currencyCode
        screenView.amountInputView.layoutSubviews()
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
