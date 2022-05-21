//
//  EditReplenishmentScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.05.2022.
//

import UIKit
import AUIKit

final class EditReplenishmentScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    let replenishment: Replenishment
    var accounts: [Account]
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var editReplenishmentClosure: ((EditingReplenishment) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, replenishment: Replenishment, accounts: [Account]) {
        self.replenishment = replenishment
        self.accounts = accounts
        self.accountPickerController = BalanceAccountHorizontalPickerController(locale: locale, appearance: appearance)
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
    
    private let accountPickerController: BalanceAccountHorizontalPickerController
    private let amountInputController = TextFieldLabelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupAccountPickerController()
        setupAmountInputController()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        screenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupErrorSnackbarViewController()
        setContent()
        
        accountPickerController.setSelectedAccount(replenishment.account)
        setupDayDatePickerController()
        dayDatePickerController.setSelectedDate(replenishment.timestamp)
        amountInputController.labelController.text = replenishment.account.currency.rawValue
        amountInputController.textFieldController.text = NumberFormatter().string(from: replenishment.amount as NSNumber)
        screenView.commentTextField.text = replenishment.comment
    }
    
    private func setupAccountPickerController() {
        accountPickerController.balanceAccountHorizontalPickerView = screenView.accountPickerView
        accountPickerController.didSelectAccountClosure = { [weak self] account in
            guard let self = self else { return }
            self.screenView.amountInputView.label.text = account.currency.rawValue
            self.screenView.amountInputView.setNeedsLayout()
            self.screenView.amountInputView.layoutIfNeeded()
        }
        accountPickerController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccountClosure?()
        }
    }
    
    private func setupAmountInputController() {
        amountInputController.textFieldLabelView = screenView.amountInputView
    }
    
    // MARK: Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: locale.language, stringsTableName: "EditReplenishmentScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        accountPickerController.changeLocale(locale)
        dayDatePickerController.changeLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.accountPickerLabel.text = localizer.localizeText("account")
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        accountPickerController.showOptions(accounts: accounts)
    }
    
    // MARK: Events
    
    @objc
    private func backButtonTouchUpInsideEventAction() {
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
        guard let account = accountPickerController.selectedAccount else {
            showErrorSnackbar(localizer.localizeText("emptyAccountErrorMessage"))
            return
        }
        let timestamp = dayDatePickerController.selectedDate
        guard let amount = getInputAmount() else {
            showErrorSnackbar(localizer.localizeText("invalidAmountErrorMessage"))
            return
        }
        let comment = screenView.commentTextField.text
        let editingReplenishment = EditingReplenishment(id: replenishment.id, timestamp: timestamp, account: account, amount: amount, comment: comment)
        editReplenishmentClosure?(editingReplenishment)
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        accountPickerController.showOptions(accounts: accounts)
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
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
    
}
