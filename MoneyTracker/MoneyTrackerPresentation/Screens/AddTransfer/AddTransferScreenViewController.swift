//
//  TransferScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 05.04.2022.
//

import UIKit
import AUIKit

final class AddTransferScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    var accounts: [Account]
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var addTransferClosure: ((AddingTransfer) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, accounts: [Account]) {
        self.accounts = accounts
        self.fromAccountPickerController = BalanceAccountHorizontalPickerController(language: language)
        self.toAccountPickerController = BalanceAccountHorizontalPickerController(language: language)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
        
    override func loadView() {
        view = ScreenView()
    }
    
    private let fromAccountPickerController: BalanceAccountHorizontalPickerController
    private let toAccountPickerController: BalanceAccountHorizontalPickerController
    private let fromAmountInputController = TextFieldLabelController()
    private let toAmountInputController = TextFieldLabelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupFromAccountPickerController()
        setupToAccountPickerController()
        setupFromAmountInputController()
        setupToAmountInputController()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        screenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        setContent()
    }
    
    private func setupFromAccountPickerController() {
        fromAccountPickerController.balanceAccountHorizontalPickerView = screenView.fromAccountPickerView
        fromAccountPickerController.didSelectAccountClosure = { [weak self] account in
            guard let self = self else { return }
            self.screenView.fromAmountInputView.label.text = account.currency.rawValue
            self.screenView.fromAmountInputView.setNeedsLayout()
            self.screenView.fromAmountInputView.layoutIfNeeded()
        }
        fromAccountPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccountClosure?()
        }
    }
    
    private func setupToAccountPickerController() {
        toAccountPickerController.balanceAccountHorizontalPickerView = screenView.toAccountPickerView
        toAccountPickerController.didSelectAccountClosure = { [weak self] account in
            guard let self = self else { return }
            self.screenView.toAmountInputView.label.text = account.currency.rawValue
            self.screenView.toAmountInputView.setNeedsLayout()
            self.screenView.toAmountInputView.layoutIfNeeded()
        }
        toAccountPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccountClosure?()
        }
    }
    
    private func setupFromAmountInputController() {
        fromAmountInputController.textFieldLabelView = screenView.fromAmountInputView
    }
    
    private func setupToAmountInputController() {
        toAmountInputController.textFieldLabelView = screenView.toAmountInputView
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "AddTransferScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        localizer.changeLanguage(language)
        fromAccountPickerController.changeLanguage(language)
        toAccountPickerController.changeLanguage(language)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.fromAccountPickerLabel.text = localizer.localizeText("fromAccount")
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        if let firstAccount = accounts.first {
            fromAccountPickerController.showOptions(accounts: accounts, selectedAccount: firstAccount)
            fromAmountInputController.labelController.text = firstAccount.currency.rawValue
        }
        if let firstAccount = accounts.first {
            toAccountPickerController.showOptions(accounts: accounts, selectedAccount: firstAccount)
            toAmountInputController.labelController.text = firstAccount.currency.rawValue
        }
        screenView.toAccountPickerLabel.text = localizer.localizeText("toAccount")
    }
    
    // MARK: Events
        
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        screenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        screenView.setKeyboardFrame(nil)
    }
    
    @objc private func addButtonTouchUpInsideEventAction() {
        guard let fromAccount = fromAccountPickerController.selectedAccount else { return }
        guard let toAccount = toAccountPickerController.selectedAccount else { return }
        let day = screenView.dayDatePickerView.date
        guard let fromAmount = getInputFromAmount() else { return }
        guard let toAmount = getInputToAmount() else { return }
        let comment = screenView.commentTextField.text
        let addingTransfer = AddingTransfer(fromAccount: fromAccount, toAccount: toAccount, day: day, fromAmount: fromAmount, toAmount: toAmount, comment: comment)
        addTransferClosure?(addingTransfer)
    }
    
    private func getInputFromAmount() -> Decimal? {
        guard let amountText = fromAmountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
    
    private func getInputToAmount() -> Decimal? {
        guard let amountText = toAmountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        if let selectedAccount = fromAccountPickerController.selectedAccount {
            fromAccountPickerController.showOptions(accounts: accounts, selectedAccount: selectedAccount)
        }
        if let selectedAccount = toAccountPickerController.selectedAccount {
            toAccountPickerController.showOptions(accounts: accounts, selectedAccount: selectedAccount)
        }
    }
    
}
