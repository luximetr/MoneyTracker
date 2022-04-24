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
    
    init(appearance: Appearance, language: Language, account: Account, accountColors: [AccountColor]) {
        self.account = account
        self.selectedCurrency = account.currency
        self.accountColors = accountColors
        self.colorPickerController = BalanceAccountColorHorizontalPickerController(appearance: appearance)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var selectCurrencyClosure: (() -> Void)?
    var editAccountClosure: ((EditingAccount) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "EditAccountScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
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
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        setContent()
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
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func editButtonTouchUpInsideEventAction() {
        let name = screenView.nameInputView.text
        guard let balanceString = screenView.amountInputView.text else { return }
        guard let amount = balanceNumberFormatter.number(from: balanceString)?.decimalValue else { return }
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
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        colorPickerController.changeAppearance(appearance)
        if let selectedAccountColor = selectedAccountColor {
            didSelectAccountColor(selectedAccountColor)
        }
    }
    
}
