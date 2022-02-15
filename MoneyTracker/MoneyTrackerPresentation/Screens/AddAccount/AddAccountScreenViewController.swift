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
    
    private let colorsCollectionViewController = AUIEmptyCollectionViewController()
    private func backgroundColorCellController(_ backgroundColor: UIColor) -> ColorCollectionViewCellController? {
        let cellControllers = colorsCollectionViewController.sectionControllers.map({ $0.cellControllers }).reduce([], +)
        let backgroundColorCellController = cellControllers.first(where: { ($0 as? ColorCollectionViewCellController)?.backgroundColor == backgroundColor }) as? ColorCollectionViewCellController
        return backgroundColorCellController
    }
    
    private func setupColorsCollectionViewController() {
        colorsCollectionViewController.collectionView = addAccountScreenView.colorsCollectionView
    }
    
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
        addAccountScreenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        addAccountScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addAccountScreenView.colorsTitleLabel.text = localizer.localizeText("colorsTitle")
        setupColorsCollectionViewController()
        setColorsCollectionViewControllerContent()
        selectedBackgroundColor = backgroundColors.first
        if let selectedBackgroundColor = self.selectedBackgroundColor, let selectedBackgroundColorCellController = backgroundColorCellController(selectedBackgroundColor) {
            selectedBackgroundColorCellController.setSelected(true, animated: false)
            self.addAccountScreenView.setBackgroundColor(selectedBackgroundColor, animated: false)
        }
        addAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
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
    
    @objc private func addButtonTouchUpInsideEventAction() {
        guard let name = addAccountScreenView.nameInputView.text else { return }
        guard let balanceString = addAccountScreenView.amountInputView.text else { return }
        guard let amount = balanceNumberFormatter.number(from: balanceString)?.decimalValue else { return }
        guard let backgroundColor = selectedBackgroundColor else { return }
        let balance = Balance(amount: amount, currency: selectedCurrency)
        let addingAccount = AddingAccount(name: name, balance: balance, backgroundColor: backgroundColor)
        addAccountClosure?(addingAccount)
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
            self.addAccountScreenView.setBackgroundColor(selectedBackgroundColor, animated: true)
        }
    }
    
    func setSelectedCurrency(_ selectedCurrency: Currency, animated: Bool) {
        self.selectedCurrency = selectedCurrency
        addAccountScreenView.currencyInputView.setTitle(selectedCurrency.rawValue, for: .normal)
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
                let cell = self.addAccountScreenView.colorCollectionViewCell(indexPath)
                return cell
            }
            cellController.sizeForCellClosure = { [weak self] in
                guard let self = self else { return .zero }
                let size = self.addAccountScreenView.colorCollectionViewCellSize()
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
