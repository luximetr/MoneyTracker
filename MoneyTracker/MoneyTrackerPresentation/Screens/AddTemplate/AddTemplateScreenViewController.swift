//
//  AddTemplateScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

class AddTemplateScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    private let categories: [Category]
    private let balanceAccounts: [Account]
    
    // MARK: - Life cycle
    
    init(categories: [Category], balanceAccounts: [Account]) {
        self.categories = categories
        self.balanceAccounts = balanceAccounts
    }
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var addTemplateClosure: ((AddingExpenseTemplate) -> Void)?
    
    // MARK: - Localizer
    
    // MARK: - View
    
    private var addTemplateScreenView: AddTemplateScreenView {
        return view as! AddTemplateScreenView
    }
    
    override func loadView() {
        view = AddTemplateScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTemplateScreenView.addButton.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        addTemplateScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
    }
    
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
}
