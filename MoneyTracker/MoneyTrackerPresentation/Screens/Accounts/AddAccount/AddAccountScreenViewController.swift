//
//  AddAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

final class AddAccountScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private let accountColors: [AccountColor]
    var selectedCurrency: Currency
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, accountColors: [AccountColor], selectedCurrency: Currency) {
        self.accountColors = accountColors
        self.selectedCurrency = selectedCurrency
        self.colorPickerController = BalanceAccountColorHorizontalPickerController(appearance: appearance)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var selectCurrencyClosure: (() -> Void)?
    var addAccountClosure: ((AddingAccount) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "AddAccountScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
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
    
    private var balanceNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
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
        setupColorPickerController()
        setColorPickerControllerContent()
        screenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
        screenView.currencyInputView.addTarget(self, action: #selector(currencyButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceTextFieldInputController.textField = screenView.amountInputView
        balanceTextFieldInputController.keyboardType = .decimalPad
        balanceTextFieldInputController.textInputValidator = MoneySumTextInputValidator()
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
        guard let accountColor = selectedAccountColor else {
            showErrorSnackbar(localizer.localizeText("emptyColorErrorMessage"))
            return
        }
        let addingAccount = AddingAccount(name: name, amount: amount, currency: selectedCurrency, color: accountColor)
        addAccountClosure?(addingAccount)
    }
    
    @objc private func currencyButtonTouchUpInsideEventAction() {
        selectCurrencyClosure?()
    }
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = screenView.colorPickerView
    }
    
    private var selectedAccountColor: AccountColor? {
        return colorPickerController.selectedColor
    }
    
    private let uiColorProvider = AccountColorUIColorProvider()
    
    private func didSelectAccountColor(_ accountColor: AccountColor) {
        let uiColor = uiColorProvider.getUIColor(accountColor: accountColor, appearance: appearance)
        self.screenView.setBackgroundColor(uiColor, animated: true)
        screenView.addButton.backgroundColor = uiColor
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        screenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
    }
    
    // MARK: Content
    
    private func setColorPickerControllerContent() {
        guard let firstColor = accountColors.first else { return }
        colorPickerController.setColors(accountColors, selectedColor: firstColor)
        didSelectAccountColor(firstColor)
        colorPickerController.didSelectColorClosure = { [weak self] color in
            guard let self = self else { return }
            self.didSelectAccountColor(color)
        }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
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
