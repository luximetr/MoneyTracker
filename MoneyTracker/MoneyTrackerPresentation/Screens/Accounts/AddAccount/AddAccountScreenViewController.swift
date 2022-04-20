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
    
    private let backgroundColors: [UIColor]
    var selectedCurrency: Currency
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, backgroundColors: [UIColor], selectedCurrency: Currency) {
        self.backgroundColors = backgroundColors
        self.selectedCurrency = selectedCurrency
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
    
    private let colorPickerController = ColorHorizontalPickerController()
    
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
        screenView.addButton.backgroundColor = selectedBackgroundColor
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
        guard let backgroundColor = selectedBackgroundColor else { return }
        let addingAccount = AddingAccount(name: name, amount: amount, currency: selectedCurrency, backgroundColor: backgroundColor)
        addAccountClosure?(addingAccount)
    }
    
    @objc private func currencyButtonTouchUpInsideEventAction() {
        selectCurrencyClosure?()
    }
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = screenView.colorPickerView
    }
    
    private var selectedBackgroundColor: UIColor? {
        return colorPickerController.selectedColor
    }
    private func didSelectBackgroundColor(_ backgroundColor: UIColor) {
        self.screenView.setBackgroundColor(backgroundColor, animated: true)
        screenView.addButton.backgroundColor = selectedBackgroundColor
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        screenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
    }
    
    // MARK: Content
    
    private func setColorPickerControllerContent() {
        guard let firstColor = backgroundColors.first else { return }
        colorPickerController.setColors(backgroundColors, selectedColor: firstColor)
        didSelectBackgroundColor(firstColor)
        colorPickerController.didSelectColorClosure = { [weak self] color in
            guard let self = self else { return }
            self.didSelectBackgroundColor(color)
        }
    }
    
}
