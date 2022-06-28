//
//  SelectCurrencyScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.02.2022.
//

import UIKit
import AUIKit

class SelectCurrencyScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var didSelectCurrencyClosure: ((Currency) -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, currencies: [Currency], selectedCurrency: Currency) {
        self.currencies = currencies
        self.selectedCurrency = selectedCurrency
        self.currencyNameProvider = CurrencyNameLocalizer(locale: locale)
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "SelectCurrencyScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        setContent()
    }
    
    private func setContent() {
        selectCurrencyScreenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        selectCurrencyScreenView.changeAppearance(appearance)
        currenciesCellControllers.forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var selectCurrencyScreenView: ScreenView! {
        return view as? ScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCurrencyScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    // MARK: - TableView
    
    private let tableViewController = AUIEmptyTableViewController()
    private let currenciesSectionController = AUIEmptyTableViewSectionController()
    
    private func setupTableViewController() {
        tableViewController.tableView = selectCurrencyScreenView.tableView
        let cellControllers = createCurrenciesCellControllers(currencies: currencies)
        currenciesSectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [currenciesSectionController]
    }
    
    // MARK: - Currency - Data
    
    private let currencies: [Currency]
    private var selectedCurrency: Currency
    private let currencyNameProvider: CurrencyNameLocalizer
    
    // MARK: - Currency - Cell
    
    private func createCurrenciesCellControllers(currencies: [Currency]) -> [AUITableViewCellController] {
        return currencies.map { createCurrencyCellController(currency: $0) }
    }
    
    private func createCurrencyCellController(currency: Currency) -> AUITableViewCellController {
        let isSelected = currency == selectedCurrency
        let currencyName = currencyNameProvider.name(currency)
        let selectCurrencyCellController = CurrencyTableViewCellController(appearance: appearance, currency: currency, currencyName: currencyName, isSelected: isSelected)
        selectCurrencyCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            return self.selectCurrencyScreenView.currencyTableViewCell(indexPath)
        }
        selectCurrencyCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.selectCurrencyScreenView.currencyTableViewCellEstimatedHeight()
        }
        selectCurrencyCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.selectCurrencyScreenView.currencyTableViewCellHeight()
        }
        selectCurrencyCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCurrency(currency)
        }
        return selectCurrencyCellController
    }
    
    private func findCellControllerForCurrency(_ currency: Currency) -> CurrencyTableViewCellController? {
        let cellControllers = tableViewController.sectionControllers.map({ $0.cellControllers }).reduce([], +)
        let selectCurrencyTableViewCellController = cellControllers.first(where: { ($0 as? CurrencyTableViewCellController)?.currency == currency }) as? CurrencyTableViewCellController
        return selectCurrencyTableViewCellController
    }
    
    private var currenciesCellControllers: [CurrencyTableViewCellController] {
        return currenciesSectionController.cellControllers.compactMap { $0 as? CurrencyTableViewCellController }
    }
    
    private func showSelectedCurrency(_ currency: Currency) {
        guard let cellController = findCellControllerForCurrency(currency) else { return }
        cellController.isSelected = true
    }
    
    private func showDeselectedCurrency(_ currency: Currency) {
        guard let cellController = findCellControllerForCurrency(currency) else { return }
        cellController.isSelected = false
    }
    
    // MARK: - Events
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
    
    private func didSelectCurrency(_ currency: Currency) {
        showDeselectedCurrency(selectedCurrency)
        showSelectedCurrency(currency)
        selectedCurrency = currency
        didSelectCurrencyClosure?(currency)
    }
}
