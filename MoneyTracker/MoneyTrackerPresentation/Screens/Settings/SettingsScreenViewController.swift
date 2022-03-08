//
//  SettingsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

final class SettingsScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Delegation
    
    var didSelectCategoriesClosure: (() -> Void)?
    var didSelectCurrencyClosure: (() -> Void)?
    var didSelectAccountsClosure: (() -> Void)?
    var didSelectTemplatesClosure: (() -> Void)?
    var didSelectImportCSVClosure: (() -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = SettingsScreenView()
    }
    
    private var settingsScreenView: SettingsScreenView! {
        return view as? SettingsScreenView
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "SettingsScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsScreenView.titleLabel.text = localizer.localizeText("title")
        setupTableViewController()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = settingsScreenView.tableView
        let sectionController = AUIEmptyTableViewSectionController()
        var cellControllers: [AUITableViewCellController] = []
        let categoriesCellController = CategoriesScreenAddCategoryTableViewCellController()
        categoriesCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.settingsScreenView.titleItemTableViewCell(indexPath)!
            cell.nameLabel.text = self.localizer.localizeText("categories")
            return cell
        }
        categoriesCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.settingsScreenView.titleItemTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        categoriesCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.settingsScreenView.titleItemTableViewCellHeight()
            return height
        }
        categoriesCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCategories()
        }
        cellControllers.append(categoriesCellController)
        
        let currencyCellController = CategoriesScreenAddCategoryTableViewCellController()
        currencyCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.settingsScreenView.titleItemTableViewCell(indexPath)!
            cell.nameLabel.text = self.localizer.localizeText("defaultCurrency")
            return cell
        }
        currencyCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.settingsScreenView.titleItemTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        currencyCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.settingsScreenView.titleItemTableViewCellHeight()
            return height
        }
        currencyCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCurrency()
        }
        cellControllers.append(currencyCellController)

        let accountsCellController = CategoriesScreenAddCategoryTableViewCellController()
        accountsCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.settingsScreenView.titleItemTableViewCell(indexPath)!
            cell.nameLabel.text = self.localizer.localizeText("accounts")
            return cell
        }
        accountsCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.settingsScreenView.titleItemTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        accountsCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.settingsScreenView.titleItemTableViewCellHeight()
            return height
        }
        accountsCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAccounts()
        }
        cellControllers.append(accountsCellController)
        
        let templatesCellController = CategoriesScreenAddCategoryTableViewCellController()
        templatesCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.settingsScreenView.titleItemTableViewCell(indexPath)!
            cell.nameLabel.text = self.localizer.localizeText("templates")
            return cell
        }
        templatesCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.settingsScreenView.titleItemTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        templatesCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.settingsScreenView.titleItemTableViewCellHeight()
            return height
        }
        templatesCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectTemplates()
        }
        cellControllers.append(templatesCellController)
        
        let importCSVCellController = CategoriesScreenAddCategoryTableViewCellController()
        importCSVCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.settingsScreenView.titleItemTableViewCell(indexPath)!
            cell.nameLabel.text = self.localizer.localizeText("importCSV")
            return cell
        }
        importCSVCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.settingsScreenView.titleItemTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        importCSVCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.settingsScreenView.titleItemTableViewCellHeight()
            return height
        }
        importCSVCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectImportCSV()
        }
        cellControllers.append(importCSVCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    // MARK: Events
    
    private func didSelectCategories() {
        didSelectCategoriesClosure?()
    }
    
    private func didSelectCurrency() {
        didSelectCurrencyClosure?()
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
    
}
