//
//  TotalAmountViewSettingScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import UIKit
import AUIKit

final class TotalAmountViewSettingsScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private let totalAmountViewSettings: [TotalAmountViewSetting]
    private var selectedTotalAmountViewSetting: TotalAmountViewSetting
    
    // MARK: - Actions
    
    var back: (() -> Void)?
    
    var selectTotalAmountViewSetting: ((TotalAmountViewSetting) throws -> Void)?
    
    private func selectTotalAmountViewSettingSettingContent(_ totalAmountViewSetting: TotalAmountViewSetting) {
        guard let selectTotalAmountViewSetting = selectTotalAmountViewSetting else { return }
        guard selectedTotalAmountViewSetting != totalAmountViewSetting else { return }
        do {
            try selectTotalAmountViewSetting(totalAmountViewSetting)
            let currentSelectedCellController = totalAmountViewSettingTableViewCellController(selectedTotalAmountViewSetting)
            currentSelectedCellController?.setIsSelected(false)
            let selectedCellController = totalAmountViewSettingTableViewCellController(totalAmountViewSetting)
            selectedCellController?.setIsSelected(true)
            selectedTotalAmountViewSetting = totalAmountViewSetting
        } catch { }
    }
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, calendar: Calendar, totalAmountViewSettings: [TotalAmountViewSetting], selectedTotalAmountViewSetting: TotalAmountViewSetting) {
        self.totalAmountViewSettings = totalAmountViewSettings
        self.selectedTotalAmountViewSetting = selectedTotalAmountViewSetting
        super.init(appearance: appearance, locale: locale, calendar: calendar)
    }
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    private let sectionController = AUIEmptyTableViewSectionController()
    private var totalAmountViewSettingTableViewCellControllers: [TotalAmountViewSettingTableViewCellController]? {
        let cellControllers = sectionController.cellControllers
        let totalAmountViewSettingTableViewCellControllers = cellControllers as? [TotalAmountViewSettingTableViewCellController]
        return totalAmountViewSettingTableViewCellControllers
    }
    private func totalAmountViewSettingTableViewCellController(_ appearanceSetting: TotalAmountViewSetting) -> TotalAmountViewSettingTableViewCellController? {
        let appearanceSettingTableViewCellController = totalAmountViewSettingTableViewCellControllers?.first(where: { $0.totalAmountViewSetting == appearanceSetting })
        return appearanceSettingTableViewCellController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
    }
    
    // MARK: - Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        back?()
    }
    
    // MARK: - Localization
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "TotalAmountViewSettingsScreenStrings")
        return localizer
    }()
    
    private lazy var totalAmountViewSettingNameLocalizer: TotalAmountViewSettingNameLocalizer = {
        let totalAmountViewSettingNameLocalizer = TotalAmountViewSettingNameLocalizer(locale: locale)
        return totalAmountViewSettingNameLocalizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        localizer.setLocale(locale)
        totalAmountViewSettingNameLocalizer.setLocale(locale)
        setContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var cellControllers: [AUITableViewCellController] = []
        for totalAmountViewSetting in totalAmountViewSettings {
            let isSelected = totalAmountViewSetting == selectedTotalAmountViewSetting
            let example: String
            switch totalAmountViewSetting {
            case .basicCurrency:
                example = localizer.localizeText("basicCurrencyExample")
            case .originalCurrencies:
                example = localizer.localizeText("originalCurrenciesExample")
            }
            let cellController = TotalAmountViewSettingTableViewCellController(appearance: appearance, totalAmountViewSetting: totalAmountViewSetting, example: example, isSelected: isSelected, totalAmountViewSettingNameLocalizer: totalAmountViewSettingNameLocalizer)
            cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UITableViewCell() }
                let cell = self.screenView.appearanceSettingTableViewCell(indexPath)
                return cell
            }
            cellController.estimatedHeightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return self.screenView.appearanceSettingTableViewCellEstimatedHeight()
            }
            cellController.heightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return self.screenView.appearanceSettingTableViewCellHeight()
            }
            cellController.didSelectClosure = { [weak self, weak cellController] in
                guard let self = self else { return }
                guard let cellController = cellController else { return }
                let totalAmountViewSetting = cellController.totalAmountViewSetting
                self.selectTotalAmountViewSettingSettingContent(totalAmountViewSetting)
            }
            cellControllers.append(cellController)
        }
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    private var appearancesSettingCells: [TotalAmountViewSettingTableViewCellController] {
        return sectionController.cellControllers.compactMap { $0 as? TotalAmountViewSettingTableViewCellController }
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.setAppearance(appearance)
        appearancesSettingCells.forEach { $0.setAppearance(appearance) }
    }
}
