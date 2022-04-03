//
//  AddAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

final class AddAccountScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private let backgroundColors: [UIColor]
    var selectedCurrency: Currency
    
    // MARK: Initializer
    
    init(backgroundColors: [UIColor], selectedCurrency: Currency) {
        self.backgroundColors = backgroundColors
        self.selectedCurrency = selectedCurrency
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var selectCurrencyClosure: (() -> Void)?
    var addAccountClosure: ((AddingAccount) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddAccountScreenStrings")
        return localizer
    }()
    
    // MARK: View
    
    override func loadView() {
        view = AddAccountScreenView()
    }
    
    private var addAccountScreenView: AddAccountScreenView! {
        return view as? AddAccountScreenView
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
        addAccountScreenView.titleLabel.text = localizer.localizeText("title")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addAccountScreenView.addButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        addAccountScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addAccountScreenView.colorsTitleLabel.text = localizer.localizeText("colorsTitle")
        setupColorPickerController()
        setColorPickerControllerContent()
        addAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
        addAccountScreenView.addButton.backgroundColor = selectedBackgroundColor
        addAccountScreenView.currencyInputView.addTarget(self, action: #selector(currencyButtonTouchUpInsideEventAction), for: .touchUpInside)
        addAccountScreenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceTextFieldInputController.textField = addAccountScreenView.amountInputView
        balanceTextFieldInputController.keyboardType = .decimalPad
        balanceTextFieldInputController.textInputValidator = MoneySumTextInputValidator()
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        addAccountScreenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        addAccountScreenView.setKeyboardFrame(nil)
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func editButtonTouchUpInsideEventAction() {
        guard let name = addAccountScreenView.nameInputView.text else { return }
        guard let balanceString = addAccountScreenView.amountInputView.text else { return }
        guard let amount = balanceNumberFormatter.number(from: balanceString)?.decimalValue else { return }
        guard let backgroundColor = selectedBackgroundColor else { return }
        let addingAccount = AddingAccount(name: name, amount: amount, currency: selectedCurrency, backgroundColor: backgroundColor)
        addAccountClosure?(addingAccount)
    }
    
    @objc private func currencyButtonTouchUpInsideEventAction() {
        selectCurrencyClosure?()
    }
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = addAccountScreenView.colorPickerView
    }
    
    private var selectedBackgroundColor: UIColor? {
        return colorPickerController.selectedColor
    }
    private func didSelectBackgroundColor(_ backgroundColor: UIColor) {
        self.addAccountScreenView.setBackgroundColor(backgroundColor, animated: true)
        addAccountScreenView.addButton.backgroundColor = selectedBackgroundColor
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        addAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
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
