//
//  AddTemplateScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

class AddTemplateScreenViewController: AUIStatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var addTemplateClosure: ((AddingExpenseTemplate) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddTemplateScreenStrings")
        return localizer
    }()
    
    // MARK: - Data
    
    private let categories: [Category]
    private let balanceAccounts: [Account]
    
    // MARK: - Life cycle
    
    init(categories: [Category], balanceAccounts: [Account]) {
        self.categories = categories
        self.balanceAccounts = balanceAccounts
    }
    
    // MARK: - View
    
    private var addTemplateScreenView: AddTemplateScreenView {
        return view as! AddTemplateScreenView
    }
    
    // MARK: - View - Life cycle
    
    override func loadView() {
        view = AddTemplateScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBalanceAccountPickerController()
        setupCategoryPickerController()
        setupNameTextFieldController()
        setupCommentTextFieldController()
        setupAmountTextFieldController()
        addTemplateScreenView.titleLabel.text = localizer.localizeText("title")
        addTemplateScreenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        addTemplateScreenView.categoryPickerHeaderLabel.text = localizer.localizeText("categoryPickerHeader")
        addTemplateScreenView.nameTextField.placeholder = localizer.localizeText("namePlaceholder")
        addTemplateScreenView.amountInputView.placeholder = localizer.localizeText("amountPlaceholder")
        addTemplateScreenView.amountInputView.label.text = balanceAccountPickerController.selectedAccount?.currency.rawValue
        addTemplateScreenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        addTemplateScreenView.addButton.setTitle(localizer.localizeText("addButtonTitle"), for: .normal)
        addTemplateScreenView.addButton.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        addTemplateScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        showAmountInputCurrencyCode(selectedBalanceAccount?.currency.rawValue)
    }
    
    // MARK: - View - Actions
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    // MARK: - Balance account picker
    
    private let balanceAccountPickerController = BalanceAccountHorizontalPickerController()
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = addTemplateScreenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        guard let firstAccount = balanceAccounts.first else { return }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: firstAccount)
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
        categoryPickerController.categoryHorizontalPickerView = addTemplateScreenView.categoryPickerView
        guard let firstCategory = categories.first else { return }
        categoryPickerController.showOptions(categories: categories, selectedCategory: firstCategory)
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
            balanceAccountId: selectedAccount.id,
            categoryId: selectedCategory.id
        )
        addTemplateClosure?(addingTemplate)
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
}
