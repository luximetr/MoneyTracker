//
//  EditTransferScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 04.05.2022.
//

import UIKit
import AUIKit

final class EditTransferScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    let transfer: Transfer
    var accounts: [Account]
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var editTransferClosure: ((EditingTransfer) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, accounts: [Account], transfer: Transfer) {
        self.transfer = transfer
        self.accounts = accounts
        self.fromAccountPickerController = BalanceAccountHorizontalPickerController(locale: locale, appearance: appearance)
        self.toAccountPickerController = BalanceAccountHorizontalPickerController(locale: locale, appearance: appearance)
        self.dayDatePickerController = DateHorizontalPickerViewController(locale: locale)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
        
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private let fromAccountPickerController: BalanceAccountHorizontalPickerController
    private let toAccountPickerController: BalanceAccountHorizontalPickerController
    private let fromAmountInputController = TextFieldLabelController()
    private let toAmountInputController = TextFieldLabelController()
    private var isSameCurrencies = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewTapRecognizer()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupFromAccountPickerController()
        setupToAccountPickerController()
        setupFromAmountInputController()
        setupToAmountInputController()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        screenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupErrorSnackbarViewController()
        checkSameCurrencies()
        setContent()
        fromAccountPickerController.setSelectedAccount(transfer.fromAccount)
        fromAmountInputController.textFieldController.text = NumberFormatter().string(from: transfer.fromAmount as NSNumber)
        toAccountPickerController.setSelectedAccount(transfer.toAccount)
        toAmountInputController.textFieldController.text = NumberFormatter().string(from: transfer.toAmount as NSNumber)
        screenView.commentTextField.text = transfer.comment
        checkSameCurrencies()
        setupDayDatePickerController()
        dayDatePickerController.setSelectedDate(transfer.timestamp)
    }
    
    private func setupViewTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTapOnView() {
        view.endEditing(true)
    }
    
    private func setupFromAccountPickerController() {
        fromAccountPickerController.balanceAccountHorizontalPickerView = screenView.fromAccountPickerView
        fromAccountPickerController.didSelectAccountClosure = { [weak self] balanceAccount in
            guard let self = self else { return }
            self.didSelectFromBalanceAccount(balanceAccount)
        }
        fromAccountPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccountClosure?()
        }
    }
    
    private func setupToAccountPickerController() {
        toAccountPickerController.balanceAccountHorizontalPickerView = screenView.toAccountPickerView
        toAccountPickerController.didSelectAccountClosure = { [weak self] balanceAccount in
            guard let self = self else { return }
            self.didSelectToBalanceAccount(balanceAccount)
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
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "AddTransferScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.fromAccountPickerLabel.text = localizer.localizeText("fromAccount")
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        fromAccountPickerController.showOptions(accounts: accounts)
        let firstAccount = transfer.fromAccount
        fromAccountPickerController.setSelectedAccount(firstAccount)
        fromAmountInputController.labelController.text = firstAccount.currency.rawValue
        toAccountPickerController.showOptions(accounts: accounts)
        let toAccount = transfer.toAccount
        toAccountPickerController.setSelectedAccount(toAccount)
        toAmountInputController.labelController.text = toAccount.currency.rawValue
        screenView.toAccountPickerLabel.text = localizer.localizeText("toAccount")
    }
    
    // MARK: Events
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        localizer.changeLocale(locale)
        fromAccountPickerController.changeLocale(locale)
        toAccountPickerController.changeLocale(locale)
        dayDatePickerController.changeLocale(locale)
        setContent()
    }
        
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
        let id = transfer.id
        guard let fromAccount = fromAccountPickerController.selectedAccount else {
            showErrorSnackbar(localizer.localizeText("emptyFromAccountErrorMessage"))
            return
        }
        guard let toAccount = toAccountPickerController.selectedAccount else {
            showErrorSnackbar(localizer.localizeText("emptyToAccountErrorMessage"))
            return
        }
        let day = dayDatePickerController.selectedDate
        guard let fromAmount = getInputFromAmount() else {
            showErrorSnackbar(localizer.localizeText("emptyFromAmountErrorMessage"))
            return
        }
        let toAmount: Decimal
        if isSameCurrencies {
            toAmount = fromAmount
        } else {
            guard let _toAmount = getInputToAmount() else {
                showErrorSnackbar(localizer.localizeText("emptyToAmountErrorMessage"))
                return
            }
            toAmount = _toAmount
        }
        
        let comment = screenView.commentTextField.text
        let editingTransfer = EditingTransfer(id: id, fromAccount: fromAccount, toAccount: toAccount, day: day, fromAmount: fromAmount, toAmount: toAmount, comment: comment)
        editTransferClosure?(editingTransfer)
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
        fromAccountPickerController.showOptions(accounts: accounts)
        toAccountPickerController.showOptions(accounts: accounts)
    }
    
    private func didSelectFromBalanceAccount(_ balanceAccount: Account) {
        screenView.fromAmountInputView.label.text = balanceAccount.currency.rawValue
        screenView.fromAmountInputView.setNeedsLayout()
        screenView.fromAmountInputView.layoutIfNeeded()
        checkSameCurrencies()
    }
    
    private func didSelectToBalanceAccount(_ balanceAccount: Account) {
        screenView.toAmountInputView.label.text = balanceAccount.currency.rawValue
        screenView.toAmountInputView.setNeedsLayout()
        screenView.toAmountInputView.layoutIfNeeded()
        checkSameCurrencies()
    }
    
    private func checkSameCurrencies() {
        let isSameCurrencies = fromAccountPickerController.selectedAccount?.currency == toAccountPickerController.selectedAccount?.currency
        screenView.displayToAmountInputView(!isSameCurrencies)
        self.isSameCurrencies = isSameCurrencies
    }
    
    // MARK: - Date
    
    private let dayDatePickerController: DateHorizontalPickerViewController
    
    private func setupDayDatePickerController() {
        dayDatePickerController.pickerView = screenView.dayDatePickerView
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
