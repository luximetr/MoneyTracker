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
        balanceAccountPickerController.showOptions(accounts: balanceAccounts)
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        categoryPickerController.showOptions(categories: categories)
    }
    
    // MARK: - Life cycle
    
    init(appearance: Appearance, locale: Locale, expense: Expense, categories: [Category], balanceAccounts: [Account]) {
        self.expense = expense
        self.categories = categories
        self.balanceAccounts = balanceAccounts
        self.balanceAccountPickerController = BalanceAccountHorizontalPickerController(locale: locale, appearance: appearance)
        self.categoryPickerController = CategoryHorizontalPickerController(locale: locale, appearance: appearance)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        self.dayDatePickerController = DateHorizontalPickerViewController(locale: locale)
        super.init(appearance: appearance, locale: locale)
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
        setupDatePickerController()
        setupErrorSnackbarViewController()
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
        balanceAccountPickerController.showOptions(accounts: balanceAccounts)
        balanceAccountPickerController.setSelectedAccount(expense.account)
    }
    
    private func setupCategoryPickerController() {
        categoryPickerController.categoryHorizontalPickerView = screenView.categoryPickerView
        categoryPickerController.showOptions(categories: categories)
        categoryPickerController.setSelectedCategory(expense.category)
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
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "EditExpenseScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        balanceAccountPickerController.changeLocale(locale)
        dayDatePickerController.changeLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        screenView.categoryPickerHeaderLabel.text = localizer.localizeText("categoryPickerHeader")
        screenView.amountInputView.placeholder = localizer.localizeText("amountPlaceholder")
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.saveButton.setTitle(localizer.localizeText("saveButtonTitle"), for: .normal)
        dayDatePickerController.changeLocale(locale)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        balanceAccountPickerController.changeAppearance(appearance)
        categoryPickerController.changeAppearance(appearance)
    }
    
    // MARK: - Events
    
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
    
    // MARK: - Day picker
    
    private let dayDatePickerController: DateHorizontalPickerViewController
    
    private func setupDatePickerController() {
        dayDatePickerController.pickerView = screenView.dayDatePickerView
        dayDatePickerController.setSelectedDate(expense.timestamp)
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
        guard let selectedAccount = balanceAccountPickerController.selectedAccount else {
            showErrorSnackbar(localizer.localizeText("emptyAccountErrorMessage"))
            return
        }
        guard let selectedCategory = categoryPickerController.selectedCategory else {
            showErrorSnackbar(localizer.localizeText("emptyCategoryErrorMessage"))
            return
        }
        guard let amount = getInputAmount() else {
            showErrorSnackbar(localizer.localizeText("invalidAmountErrorMessage"))
            return
        }
        let comment = commentTextFieldController.text
        let expense = Expense(
            id: expense.id,
            timestamp: dayDatePickerController.selectedDate,
            amount: amount,
            account: selectedAccount,
            category: selectedCategory,
            comment: comment
        )
        editExpenseClosure?(expense)
        backClosure?()
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
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
