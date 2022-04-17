//
//  TopUpAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 05.04.2022.
//

import UIKit
import AUIKit

final class TopUpAccountScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    var accounts: [Account]
    var selectedAccount: Account?
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var addTopUpAccountClosure: ((AddingTopUpAccount) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, accounts: [Account], selectedAccount: Account?) {
        self.accounts = accounts
        self.selectedAccount = selectedAccount
        self.accountPickerController = BalanceAccountHorizontalPickerController(language: language)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
        
    override func loadView() {
        view = ScreenView()
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
        setContent()
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
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "TopUpAccountScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.accountPickerLabel.text = localizer.localizeText("account")
        screenView.commentTextField.placeholder = localizer.localizeText("commentPlaceholder")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        if let selectedAccount = selectedAccount {
            accountPickerController.showOptions(accounts: accounts, selectedAccount: selectedAccount)
            amountInputController.labelController.text = selectedAccount.currency.rawValue
        }
    }
    
    // MARK: Events
    
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
        guard let account = accountPickerController.selectedAccount else { return }
        let day = screenView.dayDatePickerView.date
        guard let amount = getInputAmount() else { return }
        let comment = screenView.commentTextField.text
        let addingTopUpAccount = AddingTopUpAccount(account: account, day: day, amount: amount, comment: comment)
        addTopUpAccountClosure?(addingTopUpAccount)
    }
    
    private func getInputAmount() -> Decimal? {
        guard let amountText = amountInputController.textFieldController.text else { return nil }
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: amountText)?.decimalValue
    }
    
    @objc
    private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        if let selectedAccount = accountPickerController.selectedAccount {
            accountPickerController.showOptions(accounts: accounts, selectedAccount: selectedAccount)
        }
    }
    
}
