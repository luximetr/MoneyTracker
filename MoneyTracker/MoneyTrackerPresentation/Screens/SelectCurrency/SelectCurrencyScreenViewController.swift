//
//  SelectCurrencyScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.02.2022.
//

import UIKit
import AUIKit

class SelectCurrencyScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    private let currencies: [Currency]
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var didSelectCurrencyClosure: ((Currency) -> Void)?
    
    // MARK: - Dependencies
    
    private let currencyNameProvider = CurrencyNameProvider()
    
    // MARK: - Initializer
    
    init(currencies: [Currency]) {
        self.currencies = currencies
    }
    
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
        let cellControllers = createCurrenciesCellControllers(currencies: currencies)
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    private func createCurrenciesCellControllers(currencies: [Currency]) -> [AUITableViewCellController] {
        return currencies.map { createCurrencyCellController(currency: $0) }
    }
    
    private func createCurrencyCellController(currency: Currency) -> AUITableViewCellController {
        let selectCurrencyCellController = AUIClosuresTableViewCellController()
        selectCurrencyCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.selectCurrencyScreenView.makeSelectCurrencyCell(indexPath)
            cell.nameLabel.text = self.currencyNameProvider.getCurrencyName(currency: currency)
            cell.codeLabel.text = currency.rawValue
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
            self?.didSelectCurrency(currency)
        }
        return selectCurrencyCellController
    }
    
    // MARK: - Events
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    private func didSelectCurrency(_ currency: Currency) {
        didSelectCurrencyClosure?(currency)
    }
}
