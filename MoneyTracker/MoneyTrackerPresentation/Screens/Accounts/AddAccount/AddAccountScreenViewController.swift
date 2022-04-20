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
    
    init(appearance: Appearance, language: Language, accountColors: [AccountColor], selectedCurrency: Currency) {
        self.accountColors = accountColors
        self.selectedCurrency = selectedCurrency
        self.colorPickerController = BalanceAccountColorHorizontalPickerController(appearance: appearance)
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var selectCurrencyClosure: (() -> Void)?
    var addAccountClosure: ((AddingAccount) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "AddAccountScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
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
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        screenView.addButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupColorPickerController()
        setColorPickerControllerContent()
        screenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
        screenView.currencyInputView.addTarget(self, action: #selector(currencyButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceTextFieldInputController.textField = screenView.amountInputView
        balanceTextFieldInputController.keyboardType = .decimalPad
        balanceTextFieldInputController.textInputValidator = MoneySumTextInputValidator()
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
        guard let name = screenView.nameInputView.text else { return }
        guard let balanceString = screenView.amountInputView.text else { return }
        guard let amount = balanceNumberFormatter.number(from: balanceString)?.decimalValue else { return }
        guard let accountColor = selectedAccountColor else { return }
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
    
}
