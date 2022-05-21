//
//  DashboardScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit

final class DashboardScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private var templates: [ExpenseTemplate]
    var addExpenseClosure: ((Category?) -> Void)?
    var addCategoryClosure: (() -> Void)?
    var transferClosure: (() -> Void)?
    var topUpAccountClosure: ((Account) -> Void)?
    var addAccountClosure: (() -> Void)?
    var addTemplateClosure: (() -> Void)?
    var useTemplateClosure: ((ExpenseTemplate) throws -> Void)?
    var historyClosure: (() -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, categories: [Category], accounts: [Account], templates: [ExpenseTemplate]) {
        self.templates = templates
        self.categoryPickerViewController = CategoryPickerViewController(locale: locale, appearance: appearance, categories: categories)
        self.accountPickerViewController = AccountPickerViewController(locale: locale, appearance: appearance, accounts: accounts)
        self.templatesViewController = TemplatesViewController(locale: locale, appearance: appearance, templates: templates)
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private let categoryPickerViewController: CategoryPickerViewController
    private let accountPickerViewController: AccountPickerViewController
    private let templatesViewController: TemplatesViewController
    private let templatesPanGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.historyButton.addTarget(self, action: #selector(historyButtonTouchUpInsideEventAction), for: .touchUpInside)
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
    
    // MARK: - Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: locale.language, stringsTableName: "DashboardScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        let language = locale.language
        localizer.changeLanguage(language)
        categoryPickerViewController.changeLocale(locale)
        accountPickerViewController.changeLocale(locale)
        templatesViewController.changeLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: - Events
    
    private func didSelectTemplate(_ template: ExpenseTemplate) {
        guard let useTemplateClosure = useTemplateClosure else { return }
        do {
            try useTemplateClosure(template)
        } catch {
            
        }
    }
    
    private var previousPanGestureRecognizerTranslation: CGPoint?
    @objc private func panGestureRecognizerAction() {
        let state = templatesPanGestureRecognizer.state
        let movingUp = templatesPanGestureRecognizer.translation(in: screenView).y < 0
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
            screenView.finishMove(movingUp: movingUp)
        case .cancelled:
            screenView.finishMove(movingUp: movingUp)
        case .failed:
            screenView.finishMove(movingUp: movingUp)
        @unknown default:
            screenView.finishMove(movingUp: movingUp)
        }
    }
    
    @objc private func historyButtonTouchUpInsideEventAction() {
        historyClosure?()
    }
    
    func addCategory(_ category: Category) {
        categoryPickerViewController.addCategory(category)
    }
    
    func addCategories(_ categories: [Category]) {
        categoryPickerViewController.addCategories(categories)
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
    
    func addAccounts(_ accounts: [Account]) {
        accountPickerViewController.addAccounts(accounts)
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
        screenView.finishMove(movingUp: true)
    }
    
    func editTemplate(_ template: ExpenseTemplate) {
        templatesViewController.editTemplate(template)
        screenView.finishMove(movingUp: true)
    }
    
    func deleteTemplate(_ template: ExpenseTemplate) {
        templatesViewController.deleteTemplate(template)
        screenView.finishMove(movingUp: false)
    }
    
    func orderTemplates(_ templates: [ExpenseTemplate]) {
        templatesViewController.orderTemplates(templates)
        screenView.finishMove(movingUp: true)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        categoryPickerViewController.changeAppearance(appearance)
        accountPickerViewController.changeAppearance(appearance)
        templatesViewController.changeAppearance(appearance)
    }

}
