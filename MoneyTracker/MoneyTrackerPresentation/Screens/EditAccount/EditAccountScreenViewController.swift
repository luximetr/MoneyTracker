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
        self.selectedBackgroundColor = editingAccount.backgroundColor
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
    
    private let colorsCollectionViewController = AUIEmptyCollectionViewController()
    private func backgroundColorCellController(_ backgroundColor: UIColor) -> ColorCollectionViewCellController? {
        let cellControllers = colorsCollectionViewController.sectionControllers.map({ $0.cellControllers }).reduce([], +)
        let backgroundColorCellController = cellControllers.first(where: { ($0 as? ColorCollectionViewCellController)?.backgroundColor == backgroundColor }) as? ColorCollectionViewCellController
        return backgroundColorCellController
    }
    
    private func setupColorsCollectionViewController() {
        colorsCollectionViewController.collectionView = editAccountScreenView.colorsCollectionView
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
        setupColorsCollectionViewController()
        setColorsCollectionViewControllerContent()
        if let selectedBackgroundColor = self.selectedBackgroundColor, let selectedBackgroundColorCellController = backgroundColorCellController(selectedBackgroundColor) {
            editAccountScreenView.addButton.backgroundColor = selectedBackgroundColor
            selectedBackgroundColorCellController.setSelected(true, animated: false)
            editAccountScreenView.setBackgroundColor(selectedBackgroundColor, animated: false)
        }
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
    
    private var selectedBackgroundColor: UIColor?
    private func didSelectBackgroundColor(_ backgroundColor: UIColor) {
        if let previousSelectedBackgroundColor = selectedBackgroundColor, let previousSelectedBackgroundColorCellController = backgroundColorCellController(previousSelectedBackgroundColor) {
            previousSelectedBackgroundColorCellController.setSelected(false, animated: true)
        }
        selectedBackgroundColor = backgroundColor
        if let selectedBackgroundColor = self.selectedBackgroundColor, let selectedBackgroundColorCellController = backgroundColorCellController(selectedBackgroundColor) {
            selectedBackgroundColorCellController.setSelected(true, animated: true)
            self.editAccountScreenView.setBackgroundColor(selectedBackgroundColor, animated: true)
        }
        editAccountScreenView.addButton.backgroundColor = selectedBackgroundColor
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        editAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
    }
    
    // MARK: Content
    
    private func setColorsCollectionViewControllerContent() {
        var sectionContollers: [AUICollectionViewSectionController] = []
        let sectionContoller = AUIEmptyCollectionViewSectionController()
        var cellControllers: [AUICollectionViewCellController] = []
        for backgroundColor in backgroundColors {
            let cellController = ColorCollectionViewCellController(backgroundColor: backgroundColor)
            cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UICollectionViewCell() }
                let cell = self.editAccountScreenView.colorCollectionViewCell(indexPath)
                return cell
            }
            cellController.sizeForCellClosure = { [weak self] in
                guard let self = self else { return .zero }
                let size = self.editAccountScreenView.colorCollectionViewCellSize()
                return size
            }
            cellController.didSelectClosure = { [weak self] in
                guard let self = self else { return }
                self.didSelectBackgroundColor(backgroundColor)
            }
            cellControllers.append(cellController)
        }
        sectionContoller.cellControllers = cellControllers
        sectionContollers.append(sectionContoller)
        colorsCollectionViewController.sectionControllers = sectionContollers
        colorsCollectionViewController.reload()
    }
    
}
