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
        balanceAccountPickerController.showOptions(accounts: balanceAccounts)
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        categoryPickerController.showOptions(categories: categories)
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "AddTemplateScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
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
        balanceAccountPickerController.changeAppearance(appearance)
        categoryPickerController.changeAppearance(appearance)
    }

    // MARK: - Life cycle
    
    init(appearance: Appearance, locale: Locale, categories: [Category], balanceAccounts: [Account]) {
        self.categories = categories
        self.balanceAccounts = balanceAccounts
        self.balanceAccountPickerController = BalanceAccountHorizontalPickerController(locale: locale, appearance: appearance)
        self.categoryPickerController = CategoryHorizontalPickerController(locale: locale, appearance: appearance)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        super.init(appearance: appearance, locale: locale)
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
        setupViewTapRecognizer()
        setupBalanceAccountPickerController()
        setupCategoryPickerController()
        setupNameTextFieldController()
        setupCommentTextFieldController()
        setupAmountTextFieldController()
        addTemplateScreenView.amountInputView.label.text = balanceAccountPickerController.selectedAccount?.currency.rawValue
        addTemplateScreenView.addButton.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        addTemplateScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
        setupErrorSnackbarViewController()
        setContent()
    }
    
    // MARK: - View - Actions
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    // MARK: - View - Tap Recognizer
    
    private func setupViewTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTapOnView() {
        view.endEditing(true)
    }
    
    // MARK: - Balance account picker
    
    private let balanceAccountPickerController: BalanceAccountHorizontalPickerController
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = addTemplateScreenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts)
        balanceAccountPickerController.setSelectedAccount(balanceAccounts.first)
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
        categoryPickerController.showOptions(categories: categories)
        categoryPickerController.setSelectedCategory(categories.first)
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
        nameTextFieldController.addDidTapReturnKeyObserver(self)
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
        guard let name = nameTextFieldController.text, !name.isEmpty else {
            showErrorSnackbar(localizer.localizeText("emptyNameErrorMessage"))
            return
        }
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
    
    // MARK: - Error snackbar
        
    private let errorSnackbarViewController: ErrorSnackbarViewController
    
    private func setupErrorSnackbarViewController() {
        errorSnackbarViewController.errorSnackbarView = addTemplateScreenView.errorSnackbarView
    }
    
    private func showErrorSnackbar(_ message: String) {
        errorSnackbarViewController.showMessage(message)
    }
}
