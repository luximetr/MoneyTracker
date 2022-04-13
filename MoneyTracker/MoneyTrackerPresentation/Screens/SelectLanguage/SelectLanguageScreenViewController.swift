//
//  SelectLanguageScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import UIKit
import AUIKit

final class SelectLanguageScreenViewController: AUIStatusBarScreenViewController {
    
    
    // MARK: - Currency - Data
    
    private let languages: [Language]
    private var selectedLanguage: Language
    var backClosure: (() -> Void)?
    var didSelectCurrencyClosure: ((Currency) -> Void)?
    
    // MARK: - Initializer
    
    init(languages: [Language], selectedLanguage: Language) {
        self.languages = languages
        self.selectedLanguage = selectedLanguage
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "SelectLanguageScreenStrings")
        return localizer
    }()
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView()
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    // MARK: - TableView
    
    private let tableViewController = AUIEmptyTableViewController()
    private let sectionController = AUIEmptyTableViewSectionController()
    private func findCellControllerForCurrency(_ currency: Currency) -> SelectCurrencyTableViewCellController? {
        let cellControllers = tableViewController.sectionControllers.map({ $0.cellControllers }).reduce([], +)
        let selectCurrencyTableViewCellController = cellControllers.first(where: { ($0 as? SelectCurrencyTableViewCellController)?.currency == currency }) as? SelectCurrencyTableViewCellController
        return selectCurrencyTableViewCellController
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
    }
    
    // MARK: - Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectLanguage(_ language: Language) {
        //showDeselectedCurrency(selectedCurrency)
        //showSelectedCurrency(currency)
        //selectedCurrency = currency
        //didSelectCurrencyClosure?(currency)
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewControllerContent()
    }
    
    private func setTableViewControllerContent() {
        var cellControllers: [AUITableViewCellController] = []
        for language in languages {
            let isSelected = language == selectedLanguage
            let cellController = LanguageTableViewCellController(language: language, isSelected: isSelected)
            cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UITableViewCell() }
                let cell = self.screenView.languageTableViewCell(indexPath)
                cell.nameLabel.text = "dfdfdf"
                cell.codeLabel.text = "dfdfdfdf"
                cell.isSelected = isSelected
                return cell
            }
            cellController.estimatedHeightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return self.screenView.languageTableViewCellEstimatedHeight()
            }
            cellController.heightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return self.screenView.languageTableViewCellHeight()
            }
            cellController.didSelectClosure = { [weak self] in
                guard let self = self else { return }
                self.didSelectLanguage(language)
            }
            cellControllers.append(cellController)
        }
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
}
