//
//  DashboardScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit

final class DashboardScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private var templates: [ExpenseTemplate]
    var addExpenseClosure: ((Category?) -> Void)?
    var addCategoryClosure: (() -> Void)?
    var transferClosure: (() -> Void)?
    var topUpAccountClosure: ((Account) -> Void)?
    var addAccountClosure: (() -> Void)?
    var addTemplateClosure: (() -> Void)?
    var useTemplateClosure: ((AddingExpense) throws -> Expense)?
    var displayExpenseAddedSnackbarClosure: ((Expense) -> Void)?
    
    // MARK: Initializer
    
    init(categories: [Category], accounts: [Account], templates: [ExpenseTemplate]) {
        self.templates = templates
        self.categoryPickerViewController = CategoryPickerViewController(categories: categories)
        self.accountPickerViewController = AccountPickerViewController(accounts: accounts)
        self.templatesViewController = TemplatesViewController(templates: templates)
        super.init()
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView()
    }
    
    private let categoryPickerViewController: CategoryPickerViewController
    private let accountPickerViewController: AccountPickerViewController
    private let templatesViewController: TemplatesViewController
    private let templatesPanGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryPickerViewController()
        setupAccountPickerViewController()
        setupTemplatesViewController()
        screenView.templatesView.addGestureRecognizer(templatesPanGestureRecognizer)
        templatesPanGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerAction))
        setContent()
    }
    
    private func setupCategoryPickerViewController() {
        categoryPickerViewController.categoryPickerView = screenView.categoryPickerView
        categoryPickerViewController.addExpenseClosure = { [weak self] in
            guard let self = self else { return }
            self.addExpenseClosure?(nil)
        }
        categoryPickerViewController.selectCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            self.addExpenseClosure?(category)
        }
        categoryPickerViewController.addCategoryClosure = { [weak self] in
            guard let self = self else { return }
            self.addCategoryClosure?()
        }
    }
    
    private func setupAccountPickerViewController() {
        accountPickerViewController.accountPickerView = screenView.accountPickerView
        accountPickerViewController.transferClosure = { [weak self] in
            guard let self = self else { return }
            self.transferClosure?()
        }
        accountPickerViewController.selectAccountClosure = { [weak self] account in
            guard let self = self else { return }
            self.topUpAccountClosure?(account)
        }
        accountPickerViewController.addAccountClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccountClosure?()
        }
    }
    
    private func setupTemplatesViewController() {
        templatesViewController.templatesView = screenView.templatesView
        templatesViewController.addTemplateClosure = { [weak self] in
            guard let self = self else { return }
            self.addTemplateClosure?()
        }
        templatesViewController.selectTemplateClosure = { [weak self] template in
            guard let self = self else { return }
            self.didSelectTemplate(template)
        }
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "DashboardScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: Events
    
    private func didSelectTemplate(_ template: ExpenseTemplate) {
        guard let addExpenseClosure = useTemplateClosure else { return }
        do {
            let amount = template.amount
            let date = Date()
            let component = template.comment
            let account = template.balanceAccount
            let category = template.category
            let addingExpense = AddingExpense(amount: amount, date: date, comment: component, account: account, category: category)
            let addedExpense = try addExpenseClosure(addingExpense)
            displayExpenseAddedSnackbarClosure?(addedExpense)
        } catch {
            
        }
    }
    
    private var previousPanGestureRecognizerTranslation: CGPoint?
    @objc private func panGestureRecognizerAction() {
        let state = templatesPanGestureRecognizer.state
        switch state {
        case .began:
            previousPanGestureRecognizerTranslation = templatesPanGestureRecognizer.translation(in: screenView)
        case .possible:
            break
        case .changed:
            if let previousPanGestureRecognizerTranslation = previousPanGestureRecognizerTranslation {
                let translation = templatesPanGestureRecognizer.translation(in: screenView)
                let j = translation.y - previousPanGestureRecognizerTranslation.y
                screenView.moveAccountViewIfPossible(j)
                self.previousPanGestureRecognizerTranslation = translation
            }
        case .ended:
            screenView.finishMove()
        case .cancelled:
            screenView.finishMove()
        case .failed:
            screenView.finishMove()
        @unknown default:
            screenView.finishMove()
        }
    }
    
    func addCategory(_ category: Category) {
        categoryPickerViewController.addCategory(category)
    }
    
    func editCategory(_ category: Category) {
        categoryPickerViewController.editCategory(category)
    }
    
    func deleteCategory(_ category: Category) {
        categoryPickerViewController.deleteCategory(category)
    }
    
    func orderCategories(_ categories: [Category]) {
        categoryPickerViewController.orderCategories(categories)
    }
    
    func addAccount(_ account: Account) {
        accountPickerViewController.addAccount(account)
    }
    
    func editAccount(_ account: Account) {
        accountPickerViewController.editAccount(account)
    }
    
    func deleteAccount(_ account: Account) {
        accountPickerViewController.deleteAccount(account)
    }
    
    func orderAccounts(_ accounts: [Account]) {
        accountPickerViewController.orderAccounts(accounts)
    }
    
    func addTemplate(_ template: ExpenseTemplate) {
        templatesViewController.addTemplate(template)
        screenView.finishMove()
    }
    
    func editTemplate(_ template: ExpenseTemplate) {
        templatesViewController.editTemplate(template)
        screenView.finishMove()
    }
    
    func deleteTemplate(_ template: ExpenseTemplate) {
        templatesViewController.deleteTemplate(template)
        screenView.finishMove()
    }
    
    func orderTemplates(_ templates: [ExpenseTemplate]) {
        templatesViewController.orderTemplates(templates)
        screenView.finishMove()
    }

}
