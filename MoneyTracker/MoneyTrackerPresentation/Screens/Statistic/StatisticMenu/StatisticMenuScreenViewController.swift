//
//  StatisticMenuScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit

final class StatisticMenuScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Delegation
    
    var didSelectExpensesByCategoriesClosure: (() -> Void)?
    var didSelectBalancesCalculatorClosure: (() -> Void)?
    
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
        setContent()
        tableViewController.reload()
    }
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "StatisticMenuScreenStrings")
        return localizer
    }()
    
    // MARK: - Events
    
    private func didSelectExpensesByCategories() {
        didSelectExpensesByCategoriesClosure?()
    }
    
    private func didSelectBalancesCalculator() {
        didSelectBalancesCalculatorClosure?()
    }
    
    // MARK: - Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var cellControllers: [AUITableViewCellController] = []
        
        let expensesByCategoriesCellController = createTitleTableViewCellController()
        expensesByCategoriesCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("expensesByCategories")
            return cell
        }
        expensesByCategoriesCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectExpensesByCategories()
        }
        cellControllers.append(expensesByCategoriesCellController)
        
        let balancesCalculatorCellController = createTitleTableViewCellController()
        balancesCalculatorCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.titleTableViewCell(indexPath)
            cell.titleLabel.text = self.localizer.localizeText("balancesCalculator")
            return cell
        }
        balancesCalculatorCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectBalancesCalculator()
        }
        cellControllers.append(balancesCalculatorCellController)
        
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.setAppearance(appearance)
    }
}
