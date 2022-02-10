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
    private func tableViewCellControllerForCurrency(_ currency: Currency) -> SelectCurrencyTableViewCellController? {
        let cellControllers = tableViewController.sectionControllers.map({ $0.cellControllers }).reduce([], +)
        let selectCurrencyTableViewCellController = cellControllers.first(where: { ($0 as? SelectCurrencyTableViewCellController)?.currency == currency }) as? SelectCurrencyTableViewCellController
        return selectCurrencyTableViewCellController
    }
    
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
        let currency: Currency = .sgd
        let selectCurrencyCellController = createCurrencyCellController(currency: currency)
        cellControllers.append(selectCurrencyCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    private func createCurrencyCellController(currency: Currency) -> AUITableViewCellController {
        let selectCurrencyCellController = SelectCurrencyTableViewCellController(currency: currency)
        selectCurrencyCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.selectCurrencyScreenView.makeSelectCurrencyCell(indexPath)
            cell.nameLabel.text = currency.rawValue
//            cell.codeLabel.text = currency.isoCode
            return cell
        }
        selectCurrencyCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.selectCurrencyScreenView.getSelectCurrencyTableViewCellEstimatedHeight()
        }
        selectCurrencyCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.selectCurrencyScreenView.getSelectCurrencyTableViewCellHeight()
        }
        selectCurrencyCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCurrency(currency)
            //print("did select currency")
        }
        return selectCurrencyCellController
    }
    
    // MARK: - Events
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    private func didSelectCurrency(_ currency: Currency) {
        //didSelectCurrencyClosure?(currency)
        let newSelectedCurrencyTableViewCellController = tableViewCellControllerForCurrency(currency)
        let selectCurrencyTableViewCell = newSelectedCurrencyTableViewCellController?.tableViewCell as? SelectCurrencyTableViewCell
        selectCurrencyTableViewCell?.nameLabel.textColor = .red
        print(selectCurrencyTableViewCell)
    }

}
