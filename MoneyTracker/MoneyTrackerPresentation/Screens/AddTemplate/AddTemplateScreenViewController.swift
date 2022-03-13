//
//  AddTemplateScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

class AddTemplateScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var addTemplateClosure: ((AddingExpenseTemplate) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddTemplateScreenStrings")
        return localizer
    }()
    
    // MARK: - Data
    
    private let categories: [Category]
    private let balanceAccounts: [Account]
    
    // MARK: - Life cycle
    
    init(categories: [Category], balanceAccounts: [Account]) {
        self.categories = categories
        self.balanceAccounts = balanceAccounts
    }
    
    // MARK: - View
    
    private var addTemplateScreenView: AddTemplateScreenView {
        return view as! AddTemplateScreenView
    }
    
    // MARK: - View - Life cycle
    
    override func loadView() {
        view = AddTemplateScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBalanceAccountPickerController()
        addTemplateScreenView.titleLabel.text = localizer.localizeText("title")
        addTemplateScreenView.balanceAccountPickerHeaderLabel.text = localizer.localizeText("accountPickerHeader")
        addTemplateScreenView.addButton.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        addTemplateScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
    }
    
    // MARK: - View - Actions
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    @objc
    private func didTapOnAddButton() {
        guard let balanceAccount = balanceAccounts.first else { return }
        guard let category = categories.first else { return }
        let addingTemplate = AddingExpenseTemplate(
            name: "testName",
            amount: 2,
            comment: "Bus",
            balanceAccountId: balanceAccount.id,
            categoryId: category.id
        )
        addTemplateClosure?(addingTemplate)
    }
    
    // MARK: - Balance account picker
    
    private let balanceAccountPickerController = BalanceAccountHorizontalPickerController()
    
    private func setupBalanceAccountPickerController() {
        balanceAccountPickerController.balanceAccountHorizontalPickerView = addTemplateScreenView.balanceAccountPickerView
        balanceAccountPickerController.didSelectAccountClosure = { [weak self] account in
            self?.didSelectBalanceAccount(account)
        }
        guard let firstAccount = balanceAccounts.first else { return }
        balanceAccountPickerController.showOptions(accounts: balanceAccounts, selectedAccount: firstAccount)
    }
    
    private func didSelectBalanceAccount(_ account: Account) {
        print(account.name)
    }
}
