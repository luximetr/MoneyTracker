//
//  EditAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.02.2022.
//

import UIKit
import AUIKit

final class EditAccountScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private let backgroundColors: [UIColor]
    var selectedCurrency: Currency
    private let editingAccount: Account
    
    // MARK: Initializer
    
    init(editingAccount: Account, backgroundColors: [UIColor]) {
        self.editingAccount = editingAccount
        self.selectedCurrency = editingAccount.currency
        self.backgroundColors = backgroundColors
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var selectCurrencyClosure: (() -> Void)?
    var editAccountClosure: ((Account) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "EditAccountScreenStrings")
        return localizer
    }()
    
    // MARK: View
    
    override func loadView() {
        view = EditAccountScreenView()
    }
    
    private var editAccountScreenView: EditAccountScreenView! {
        return view as? EditAccountScreenView
    }
    
    private let balanceTextFieldInputController = AUITextInputFilterValidatorFormatterTextFieldController()
    
    private let colorPickerController = ColorHorizontalPickerController()
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = editAccountScreenView.colorPickerView
        colorPickerController.didSelectColorClosure = { [weak self] color in
            self?.didSelectBackgroundColor(color)
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
        editAccountScreenView.titleLabel.text = localizer.localizeText("title")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        editAccountScreenView.addButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        editAccountScreenView.nameInputView.text = editingAccount.name
        editAccountScreenView.addButton.setTitle(localizer.localizeText("edit"), for: .normal)
        editAccountScreenView.colorsTitleLabel.text = localizer.localizeText("colorsTitle")
        setupColorPickerController()
        setColorPickerControllerContent()
        editAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
        editAccountScreenView.currencyInputView.addTarget(self, action: #selector(currencyButtonTouchUpInsideEventAction), for: .touchUpInside)
        editAccountScreenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        balanceTextFieldInputController.textField = editAccountScreenView.amountInputView
        balanceTextFieldInputController.keyboardType = .decimalPad
        balanceTextFieldInputController.textInputValidator = MoneySumTextInputValidator()
        balanceTextFieldInputController.text = balanceNumberFormatter.string(from: NSDecimalNumber(decimal: editingAccount.amount))
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        editAccountScreenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        editAccountScreenView.setKeyboardFrame(nil)
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func editButtonTouchUpInsideEventAction() {
        guard let name = editAccountScreenView.nameInputView.text else { return }
        guard let balanceString = editAccountScreenView.amountInputView.text else { return }
        guard let amount = balanceNumberFormatter.number(from: balanceString)?.decimalValue else { return }
        guard let backgroundColor = selectedBackgroundColor else { return }
        let addingAccount = Account(id: editingAccount.id, name: name, amount: amount, currency: selectedCurrency, backgroundColor: backgroundColor)
        editAccountClosure?(addingAccount)
    }
    
    @objc private func currencyButtonTouchUpInsideEventAction() {
        selectCurrencyClosure?()
    }
    
    private var selectedBackgroundColor: UIColor? {
        return colorPickerController.selectedColor
    }
    private func didSelectBackgroundColor(_ backgroundColor: UIColor) {
        self.editAccountScreenView.setBackgroundColor(backgroundColor, animated: true)
        editAccountScreenView.addButton.backgroundColor = selectedBackgroundColor
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        editAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
    }
    
    // MARK: Content
    
    private func setColorPickerControllerContent() {
        let selectedColor = editingAccount.backgroundColor
        colorPickerController.setColors(backgroundColors, selectedColor: selectedColor)
        didSelectBackgroundColor(selectedColor)
    }
    
}
