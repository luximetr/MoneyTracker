//
//  AddTemplateScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

class AddTemplateScreenViewController: StatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: Data
    
    private var categories: [Category]
    private var balanceAccounts: [Account]
    var backClosure: (() -> Void)?
    var addTemplateClosure: ((AddingExpenseTemplate) -> Void)?
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
        let localizer = ScreenLocalizer(language: language, stringsTableName: "AddTemplateScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
    private func setContent() {
        addTemplateScreenView.titleLabel.text = localizer.localizeText("title")
        addTemplateScreenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        addTemplateScreenView.categoryPickerHeaderLabel.text = localizer.localizeText("categoryPickerHeader")
        addTemplateScreenView.nameTextField.placeholder = localizer.localizeText("namePlaceholder")
        addTemplateScreenView.amountInputView.placeholder = localizer.localizeText("amountPlaceholder")
        addTemplateScreenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        addTemplateScreenView.addButton.setTitle(localizer.localizeText("addButtonTitle"), for: .normal)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        addTemplateScreenView.changeAppearance(appearance)
    }

    // MARK: - Life cycle
    
    init(appearance: Appearance, language: Language, categories: [Category], balanceAccounts: [Account]) {
        self.categories = categories
        self.balanceAccounts = balanceAccounts
        self.balanceAccountPickerController = BalanceAccountHorizontalPickerController(language: language, appearance: appearance)
        self.categoryPickerController = CategoryHorizontalPickerController(language: language)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    private var addTemplateScreenView: AddTemplateScreenView {
        return view as! AddTemplateScreenView
    }
    
    // MARK: - View - Life cycle
    
    override func loadView() {
        view = AddTemplateScreenView(appearance: appearance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBalanceAccountPickerController()
        setupCategoryPickerController()
        setupNameTextFieldController()
        setupCommentTextFieldController()
        setupAmountTextFieldController()
        addTemplateScreenView.amountInputView.label.text = balanceAccountPickerController.selectedAccount?.currency.rawValue
        addTemplateScreenView.addButton.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        addTemplateScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
        setContent()
    }
    
    // MARK: - View - Actions
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    // MARK: - Balance account picker
    
    private let balanceAccountPickerController: BalanceAccountHorizontalPickerController
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = addTemplateScreenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        guard let firstAccount = balanceAccounts.first else { return }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: firstAccount)
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
        categoryPickerController.categoryHorizontalPickerView = addTemplateScreenView.categoryPickerView
        guard let firstCategory = categories.first else { return }
        categoryPickerController.showOptions(categories: categories, selectedCategory: firstCategory)
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
        nameTextFieldController.textField = addTemplateScreenView.nameTextField
        nameTextFieldController.keyboardType = .asciiCapable
        nameTextFieldController.returnKeyType = .done
    }
    
    private func nameTextFieldDidTapReturnKey() {
        view.endEditing(true)
    }
    
    // MARK: - Amount input
    
    private let amountInputController = TextFieldLabelController()
    
    private func setupAmountTextFieldController() {
        amountInputController.textFieldLabelView = addTemplateScreenView.amountInputView
        let textFieldController = amountInputController.textFieldController
        textFieldController.keyboardType = .decimalPad
    }
    
    // MARK: - Amount input - Currency
    
    private func showAmountInputCurrencyCode(_ currencyCode: String?) {
        addTemplateScreenView.amountInputView.label.text = currencyCode
        addTemplateScreenView.amountInputView.layoutSubviews()
    }
    
    // MARK: - Comment input
    
    private let commentTextFieldController = AUIEmptyTextFieldController()
    
    private func setupCommentTextFieldController() {
        commentTextFieldController.textField = addTemplateScreenView.commentTextField
        commentTextFieldController.keyboardType = .asciiCapable
        commentTextFieldController.returnKeyType = .done
        commentTextFieldController.addDidTapReturnKeyObserver(self)
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
    
    // MARK: - Add button
    
    @objc
    private func didTapOnAddButton() {
        guard let name = nameTextFieldController.text, !name.isEmpty else { return }
        guard let selectedAccount = balanceAccountPickerController.selectedAccount else { return }
        guard let selectedCategory = categoryPickerController.selectedCategory else { return }
        guard let amount = getInputAmount() else { return }
        let comment = commentTextFieldController.text
        let addingTemplate = AddingExpenseTemplate(
            name: name,
            amount: amount,
            comment: comment,
            balanceAccount: selectedAccount,
            category: selectedCategory
        )
        addTemplateClosure?(addingTemplate)
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
}
