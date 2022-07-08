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
    var totalAmountViewSetting: TotalAmountViewSetting
    
    // MARK: - Actions
    
    var selectCategories: (() -> Void)?
    
    var selectCurrency: (() -> Void)?
    
    var selectAppearance: (() -> Void)?
    
    var selectTotalAmountView: (() -> Void)?
    
    var selectLanguage: (() -> Void)?
    
    var selectAccounts: (() -> Void)?
    
    var selectTemplates: (() -> Void)?
    
    var selectImportCsv: (() -> Void)?
    
    var selectExportCsv: (() -> Void)?
    
    func setAppearanceSetting(_ appearanceSetting: AppearanceSetting) {
        self.appearanceSetting = appearanceSetting
        tableViewController.reload()
    }
    
    func setTotalAmountViewSetting(_ totalAmountViewSetting: TotalAmountViewSetting) {
        self.totalAmountViewSetting = totalAmountViewSetting
        tableViewController.reload()
    }
    
    func setDefaultCurrency(_ defaultCurrency: Currency) {
        self.defaultCurrency = defaultCurrency
        tableViewController.reload()
    }
    
    // MARK: - Initialization
    
    init(appearance: Appearance, locale: Locale, calendar: Calendar, defaultCurrency: Currency, appearanceSetting: AppearanceSetting, totalAmountViewSetting: TotalAmountViewSetting) {
        self.defaultCurrency = defaultCurrency
        self.appearanceSetting = appearanceSetting
        self.totalAmountViewSetting = totalAmountViewSetting
        super.init(appearance: appearance, locale: locale, calendar: calendar)
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
    
    // MARK: - Localization
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        localizer.setLocale(locale)
        currencyCodeLocalizer.setLocale(locale)
        languageCodeLocalizer.setLocale(locale)
        totalAmountViewSettingNameLocalizer.setLocale(locale)
        appearanceTypeNameLocalizer.changeLocale(locale)
        setContent()
        tableViewController.reload()
    }
    
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
    
    private lazy var totalAmountViewSettingNameLocalizer: TotalAmountViewSettingNameLocalizer = {
        let localizer = TotalAmountViewSettingNameLocalizer(locale: locale)
        return localizer
    }()
    
    // MARK: - Events
    
    private func didSelectExportCSV() {
        selectExportCsv?()
    }
    
    // MARK: - Content
    
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
            guard let selectCurrency = self.selectCurrency else { return }
            selectCurrency()
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
            guard let selectLanguage = self.selectLanguage else { return }
            selectLanguage()
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
            guard let selectAppearance = self.selectAppearance else { return }
            selectAppearance()
        }
        cellControllers.append(appearanceCellController)
        
        let totalAmountViewCellController = createTitleValueTableViewCellController()
        totalAmountViewCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleValueTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("totalAmountView")
            cell.valueLabel.text = self.totalAmountViewSettingNameLocalizer.name(self.totalAmountViewSetting)
            return cell
        }
        totalAmountViewCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            guard let selectTotalAmountView = self.selectTotalAmountView else { return }
            selectTotalAmountView()
        }
        cellControllers.append(totalAmountViewCellController)
        
        let accountsCellController = createTitleTableViewCellController()
        accountsCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("accounts")
            return cell
        }
        accountsCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            guard let selectAccounts = self.selectAccounts else { return }
            selectAccounts()
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
            guard let selectCategories = self.selectCategories else { return }
            selectCategories()
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
            guard let selectTemplates = self.selectTemplates else { return }
            selectTemplates()
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
            guard let selectImportCsv = self.selectImportCsv else { return }
            selectImportCsv()
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
            guard let selectExportCsv = self.selectExportCsv else { return }
            selectExportCsv()
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
        screenView.setAppearance(appearance)
    }
}
