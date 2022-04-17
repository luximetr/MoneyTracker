//
//  EditTemplateScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 20.03.2022.
//

import UIKit
import AUIKit

class EditTemplateScreenViewController: StatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: Data
    
    private let expenseTemplate: ExpenseTemplate
    private var categories: [Category]
    private var balanceAccounts: [Account]
    var backClosure: (() -> Void)?
    var editTemplateClosure: ((EditingExpenseTemplate) -> Void)?
    var addCategoryClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    
    func addAccount(_ account: Account) {
        balanceAccounts.append(account)
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: account)
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        categoryPickerController.showOptions(categories: categories, selectedCategory: category)
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "EditTemplateScreenStrings")
        return localizer
    }()
    
    // MARK: - Life cycle
    
    init(appearance: Appearance, language: Language, expenseTemplate: ExpenseTemplate, categories: [Category], balanceAccounts: [Account]) {
        self.expenseTemplate = expenseTemplate
        self.categories = categories
        self.balanceAccounts = balanceAccounts
        self.balanceAccountPickerController = BalanceAccountHorizontalPickerController(language: language)
        self.categoryPickerController = CategoryHorizontalPickerController(language: language)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    private var editTemplateScreenView: EditTemplateScreenView {
        return view as! EditTemplateScreenView
    }
    
    // MARK: - View - Life cycle
    
    override func loadView() {
        view = EditTemplateScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBalanceAccountPickerController()
        setupCategoryPickerController()
        setupNameTextFieldController()
        setupCommentTextFieldController()
        setupAmountTextFieldController()
        editTemplateScreenView.titleLabel.text = localizer.localizeText("title")
        editTemplateScreenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        editTemplateScreenView.categoryPickerHeaderLabel.text = localizer.localizeText("categoryPickerHeader")
        editTemplateScreenView.nameTextField.placeholder = localizer.localizeText("namePlaceholder")
        editTemplateScreenView.amountInputView.placeholder = localizer.localizeText("amountPlaceholder")
        editTemplateScreenView.amountInputView.label.text = balanceAccountPickerController.selectedAccount?.currency.rawValue
        editTemplateScreenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        editTemplateScreenView.saveButton.setTitle(localizer.localizeText("saveButtonTitle"), for: .normal)
        editTemplateScreenView.saveButton.addTarget(self, action: #selector(didTapOnSaveButton), for: .touchUpInside)
        editTemplateScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
    }
    
    // MARK: - View - Actions
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    // MARK: - Balance account picker
    
    private let balanceAccountPickerController: BalanceAccountHorizontalPickerController
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = editTemplateScreenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: expenseTemplate.balanceAccount)
        balanceAccountPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccount()
        }
    }
    
    private var selectedBalanceAccount: Account? {
        return balanceAccountPickerController.selectedAccount
    }
    
    private func didSelectBalanceAccount(_ account: Account) {
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
    }
    
    private func addAccount() {
        addAccountClosure?()
    }
    
    // MARK: - Category picker
    
    private let categoryPickerController: CategoryHorizontalPickerController
    
    private func setupCategoryPickerController() {
        categoryPickerController.categoryHorizontalPickerView = editTemplateScreenView.categoryPickerView
        categoryPickerController.showOptions(categories: categories, selectedCategory: expenseTemplate.category)
        categoryPickerController.addCategoryClosure = { [weak self] in
            guard let self = self else { return }
            self.addCategory()
        }
    }
    
    private func addCategory() {
        addCategoryClosure?()
    }
    
    // MARK: - Name input
    
    private let nameTextFieldController = AUIEmptyTextFieldController()
    
    private func setupNameTextFieldController() {
        nameTextFieldController.textField = editTemplateScreenView.nameTextField
        nameTextFieldController.keyboardType = .asciiCapable
        nameTextFieldController.returnKeyType = .done
        nameTextFieldController.text = expenseTemplate.name
    }
    
    private func nameTextFieldDidTapReturnKey() {
        view.endEditing(true)
    }
    
    // MARK: - Amount input
    
    private let amountInputController = TextFieldLabelController()
    
    private func setupAmountTextFieldController() {
        amountInputController.textFieldLabelView = editTemplateScreenView.amountInputView
        let textFieldController = amountInputController.textFieldController
        textFieldController.keyboardType = .decimalPad
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        textFieldController.text = numberFormatter.string(from: NSDecimalNumber(decimal: expenseTemplate.amount))
    }
    
    // MARK: - Amount input - Currency
    
    private func showAmountInputCurrencyCode(_ currencyCode: String?) {
        editTemplateScreenView.amountInputView.label.text = currencyCode
        editTemplateScreenView.amountInputView.layoutSubviews()
    }
    
    // MARK: - Comment input
    
    private let commentTextFieldController = AUIEmptyTextFieldController()
    
    private func setupCommentTextFieldController() {
        commentTextFieldController.textField = editTemplateScreenView.commentTextField
        commentTextFieldController.keyboardType = .asciiCapable
        commentTextFieldController.returnKeyType = .done
        commentTextFieldController.addDidTapReturnKeyObserver(self)
        commentTextFieldController.text = expenseTemplate.comment
    }
    
    // MARK: - Comment input - Return Key
    
    private func commentTextFieldDidTapReturnKey() {
        view.endEditing(true)
    }
    
    // MARK: - AUITextFieldControllerDidTapReturnKeyObserver
    
    func textFieldControllerDidTapReturnKey(_ textFieldController: AUITextFieldController) {
        if textFieldController === commentTextFieldController {
            commentTextFieldDidTapReturnKey()
        } else if textFieldController === nameTextFieldController {
            nameTextFieldDidTapReturnKey()
        }
    }
    
    // MARK: - Save button
    
    @objc
    private func didTapOnSaveButton() {
        guard let name = nameTextFieldController.text, !name.isEmpty else { return }
        guard let selectedAccount = balanceAccountPickerController.selectedAccount else { return }
        guard let selectedCategory = categoryPickerController.selectedCategory else { return }
        guard let amount = getInputAmount() else { return }
        let comment = commentTextFieldController.text
        let editingTemplate = EditingExpenseTemplate(
            id: expenseTemplate.id,
            name: name,
            amount: amount,
            comment: comment,
            balanceAccountId: selectedAccount.id,
            categoryId: selectedCategory.id
        )
        editTemplateClosure?(editingTemplate)
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
}
