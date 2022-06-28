//
//  SettingsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

final class SettingsScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    var defaultCurrency: Currency
    var appearanceSetting: AppearanceSetting
    var didSelectCategoriesClosure: (() -> Void)?
    var didSelectCurrencyClosure: (() -> Void)?
    var didSelectAppearanceClosure: (() -> Void)?
    var didSelectLanguageClosure: (() -> Void)?
    var didSelectAccountsClosure: (() -> Void)?
    var didSelectTemplatesClosure: (() -> Void)?
    var didSelectImportCSVClosure: (() -> Void)?
    var didSelectExportCSVClosure: (() -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, defaultCurrency: Currency, appearanceSetting: AppearanceSetting) {
        self.defaultCurrency = defaultCurrency
        self.appearanceSetting = appearanceSetting
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView {
        return view as! ScreenView
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
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        localizer.setLocale(locale)
        currencyCodeLocalizer.changeLocale(locale)
        languageCodeLocalizer.changeLocale(locale)
        appearanceTypeNameLocalizer.changeLocale(locale)
        setContent()
        tableViewController.reload()
    }
    
    func changeAppearanceSetting(_ appearanceSetting: AppearanceSetting) {
        self.appearanceSetting = appearanceSetting
        tableViewController.reload()
    }
    
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
    
    private func didSelectLanguage() {
        didSelectLanguageClosure?()
    }
    
    private func didSelectAppearance() {
        didSelectAppearanceClosure?()
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
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "SettingsScreenStrings")
        return localizer
    }()
    
    private lazy var currencyCodeLocalizer: CurrencyCodeLocalizer = {
        let localizer = CurrencyCodeLocalizer(locale: locale)
        return localizer
    }()
    
    private lazy var languageCodeLocalizer: LanguageCodeLocalizer = {
        let localizer = LanguageCodeLocalizer(locale: locale)
        return localizer
    }()
    
    private lazy var appearanceTypeNameLocalizer: AppearanceSettingNameLocalizer = {
        let localizer = AppearanceSettingNameLocalizer(locale: locale)
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var cellControllers: [AUITableViewCellController] = []
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
            cell.valueLabel.text = self.languageCodeLocalizer.code(self.locale.language)
            return cell
        }
        languageCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectLanguage()
        }
        cellControllers.append(languageCellController)
        
        let appearanceCellController = createTitleValueTableViewCellController()
        appearanceCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleValueTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("appearance")
            cell.valueLabel.text = self.appearanceTypeNameLocalizer.name(self.appearanceSetting)
            return cell
        }
        appearanceCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAppearance()
        }
        cellControllers.append(appearanceCellController)
        
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
}
