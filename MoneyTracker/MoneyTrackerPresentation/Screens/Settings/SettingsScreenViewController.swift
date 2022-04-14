//
//  SettingsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

final class SettingsScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    var defaultCurrency: Currency
    var language: Language
    var didSelectCategoriesClosure: (() -> Void)?
    var didSelectCurrencyClosure: (() -> Void)?
    var didSelectLanguageClosure: (() -> Void)?
    var didSelectAccountsClosure: (() -> Void)?
    var didSelectTemplatesClosure: (() -> Void)?
    var didSelectImportCSVClosure: (() -> Void)?
    var didSelectExportCSVClosure: (() -> Void)?
    
    // MARK: - Initializer
    
    init(defaultCurrency: Currency, language: Language) {
        self.defaultCurrency = defaultCurrency
        self.language = language
        super.init()
    }
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView()
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    private let sectionController = AUIEmptyTableViewSectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewController()
        setContent()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
    }
    
    // MARK: - Events
    
    private func didSelectCategories() {
        didSelectCategoriesClosure?()
    }
    
    func changeDefaultCurrency(_ defaultCurrency: Currency) {
        self.defaultCurrency = defaultCurrency
        tableViewController.reload()
    }
    
    private func didSelectCurrency() {
        didSelectCurrencyClosure?()
    }
    
    func changeLanguage(_ language: Language) {
        self.language = language
        localizer.changeLanguage(language)
        currencyCodeLocalizer.changeLanguage(language)
        languageCodeLocalizer.changeLanguage(language)
        setContent()
        tableViewController.reload()
    }
    
    private func didSelectLanguage() {
        didSelectLanguageClosure?()
    }
            
    private func didSelectAccounts() {
        didSelectAccountsClosure?()
    }
    
    private func didSelectTemplates() {
        didSelectTemplatesClosure?()
    }
    
    private func didSelectImportCSV() {
        didSelectImportCSVClosure?()
    }
    
    private func didSelectExportCSV() {
        didSelectExportCSVClosure?()
    }
    
    // MARK: - Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "SettingsScreenStrings")
        return localizer
    }()
    
    private lazy var currencyCodeLocalizer: CurrencyCodeLocalizer = {
        let localizer = CurrencyCodeLocalizer(language: language)
        return localizer
    }()
    
    private lazy var languageCodeLocalizer: LanguageCodeLocalizer = {
        let localizer = LanguageCodeLocalizer(language: language)
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var cellControllers: [AUITableViewCellController] = []
        let categoriesCellController = createTitleTableViewCellController()
        categoriesCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("categories")
            return cell
        }
        categoriesCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCategories()
        }
        cellControllers.append(categoriesCellController)
        
        let defaultCurrencyCellController = createTitleValueTableViewCellController()
        defaultCurrencyCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleValueTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("defaultCurrency")
            cell.valueLabel.text = self.currencyCodeLocalizer.code(self.defaultCurrency)
            return cell
        }
        defaultCurrencyCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCurrency()
        }
        cellControllers.append(defaultCurrencyCellController)
        
        let languageCellController = createTitleValueTableViewCellController()
        languageCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleValueTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("language")
            cell.valueLabel.text = self.languageCodeLocalizer.code(self.language)
            return cell
        }
        languageCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectLanguage()
        }
        cellControllers.append(languageCellController)

        let accountsCellController = createTitleTableViewCellController()
        accountsCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("accounts")
            return cell
        }
        accountsCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAccounts()
        }
        cellControllers.append(accountsCellController)
        
        let templatesCellController = createTitleTableViewCellController()
        templatesCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("templates")
            return cell
        }
        templatesCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectTemplates()
        }
        cellControllers.append(templatesCellController)
        
        let importCSVCellController = createTitleTableViewCellController()
        importCSVCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("importCSV")
            return cell
        }
        importCSVCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectImportCSV()
        }
        cellControllers.append(importCSVCellController)
        
        let exportCSVCellController = createTitleTableViewCellController()
        exportCSVCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("exportCSV")
            return cell
        }
        exportCSVCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectExportCSV()
        }
        cellControllers.append(exportCSVCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    private func createTitleTableViewCellController() -> AUIClosuresTableViewCellController {
        let titleTableViewCellController = AUIClosuresTableViewCellController()
        titleTableViewCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.screenView.titleTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        titleTableViewCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.screenView.titleTableViewCellHeight()
            return height
        }
        return titleTableViewCellController
    }
    
    private func createTitleValueTableViewCellController() -> AUIClosuresTableViewCellController {
        let titleTableViewCellController = AUIClosuresTableViewCellController()
        titleTableViewCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.screenView.titleValueTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        titleTableViewCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.screenView.titleValueTableViewCellHeight()
            return height
        }
        return titleTableViewCellController
    }
}
