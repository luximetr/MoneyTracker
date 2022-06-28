//
//  EditAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.02.2022.
//

import UIKit
import AUIKit

final class EditAccountScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private let accountColors: [AccountColor]
    var selectedCurrency: Currency
    private let account: Account
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, account: Account, accountColors: [AccountColor]) {
        self.account = account
        self.selectedCurrency = account.currency
        self.accountColors = accountColors
        self.colorPickerController = BalanceAccountColorHorizontalPickerController(appearance: appearance)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var selectCurrencyClosure: (() -> Void)?
    var editAccountClosure: ((EditingAccount) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "EditAccountScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.addButton.setTitle(localizer.localizeText("edit"), for: .normal)
        screenView.colorsTitleLabel.text = localizer.localizeText("colorsTitle")
    }
    
    // MARK: View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    private let balanceTextFieldInputController = AUITextInputFilterValidatorFormatterTextFieldController()
    
    private let colorPickerController: BalanceAccountColorHorizontalPickerController
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = screenView.colorPickerView
        colorPickerController.didSelectColorClosure = { [weak self] color in
            self?.didSelectAccountColor(color)
        }
    }
    
    private var balanceNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ""
        return numberFormatter
    }()
    
    // MARK: - View - Tap Recognizer
    
    private func setupViewTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func didTapOnView() {
        view.endEditing(true)
    }
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewTapRecognizer()
        screenView.addButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.nameInputView.text = account.name
        setupColorPickerController()
        setColorPickerControllerContent()
        screenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
        screenView.currencyInputView.addTarget(self, action: #selector(currencyButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceTextFieldInputController.textField = screenView.amountInputView
        balanceTextFieldInputController.keyboardType = .decimalPad
        balanceTextFieldInputController.textInputValidator = MoneySumTextInputValidator()
        balanceTextFieldInputController.text = balanceNumberFormatter.string(from: NSDecimalNumber(decimal: account.amount))
        setupErrorSnackbarViewController()
        setContent()
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func editButtonTouchUpInsideEventAction() {
        guard let name = screenView.nameInputView.text, !name.isEmpty else {
            showErrorSnackbar(localizer.localizeText("emptyNameErrorMessage"))
            return
        }
        guard let balanceString = screenView.amountInputView.text, !balanceString.isEmpty else {
            showErrorSnackbar(localizer.localizeText("emptyAmountErrorMessage"))
            return
        }
        guard let amount = balanceNumberFormatter.number(from: balanceString)?.decimalValue else {
            showErrorSnackbar(localizer.localizeText("invalidAmountErrorMessage"))
            return
        }
        guard let selectedAccountColor = self.selectedAccountColor else {
            showErrorSnackbar(localizer.localizeText("emptyColorErrorMessage"))
            return
        }
        let editingAccount = EditingAccount(id: account.id, name: name, currency: selectedCurrency, amount: amount, color: selectedAccountColor)
        editAccountClosure?(editingAccount)
    }
    
    @objc private func currencyButtonTouchUpInsideEventAction() {
        selectCurrencyClosure?()
    }
    
    private let uiColorProvider = AccountColorUIColorProvider()
    
    var selectedAccountColor: AccountColor? {
        return colorPickerController.selectedColor
    }
    
    private func didSelectAccountColor(_ color: AccountColor) {
        let uiColor = uiColorProvider.getUIColor(accountColor: color, appearance: appearance)
        self.screenView.setBackgroundColor(uiColor, animated: true)
        screenView.addButton.backgroundColor = uiColor
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        screenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
    }
    
    // MARK: Content
    
    private func setColorPickerControllerContent() {
        let selectedColor = account.color
        colorPickerController.setColors(accountColors, selectedColor: selectedColor)
        didSelectAccountColor(selectedColor)
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.changeAppearance(appearance)
        colorPickerController.changeAppearance(appearance)
        if let selectedAccountColor = selectedAccountColor {
            didSelectAccountColor(selectedAccountColor)
        }
    }
    
    // MARK: - Error snackbar
    
    private let errorSnackbarViewController: ErrorSnackbarViewController
    
    private func setupErrorSnackbarViewController() {
        errorSnackbarViewController.errorSnackbarView = screenView.errorSnackbarView
    }
    
    private func showErrorSnackbar(_ message: String) {
        errorSnackbarViewController.showMessage(message)
    }
    
}
