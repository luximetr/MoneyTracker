//
//  SelectCurrencyScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.02.2022.
//

import UIKit
import AUIKit

class SelectCurrencyScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    
    // MARK: - View
    
    override func loadView() {
        view = SelectCurrencyScreenView()
    }
    
    private var selectCurrencyScreenView: SelectCurrencyScreenView! {
        return view as? SelectCurrencyScreenView
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCurrencyScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        selectCurrencyScreenView.titleLabel.text = localizer.localizeText("title")
        setupTableViewController()
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "SelectCurrencyScreenStrings")
        return localizer
    }()
    
    // MARK: - Table View
    
    private func setupTableViewController() {
        tableViewController.tableView = selectCurrencyScreenView.tableView
        let sectionController = AUIEmptyTableViewSectionController()
        var cellControllers: [AUITableViewCellController] = []
        let selectCurrencyCellController = AUIClosuresTableViewCellController()
        selectCurrencyCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.selectCurrencyScreenView.makeSelectCurrencyCell(indexPath)
            cell.nameLabel.text = "Singapore Dollar"
            cell.codeLabel.text = "SGD"
            return cell
        }
        selectCurrencyCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.selectCurrencyScreenView.getSelectCurrencyTableViewCellEstimatedHeight()
        }
        selectCurrencyCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.selectCurrencyScreenView.getSelectCurrencyTableViewCellHeight()
        }
        selectCurrencyCellController.didSelectClosure = { [weak self] in
            print("did select currency")
        }
        cellControllers.append(selectCurrencyCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    // MARK: - Events
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
}
