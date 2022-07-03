//
//  TotalAmountViewSettingScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import UIKit
import AUIKit

final class TotalAmountViewSettingScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Currency - Data
    
    private let appearanceSettings: [TotalAmountViewSetting]
    private var selectedAppearanceSetting: TotalAmountViewSetting
    var backClosure: (() -> Void)?
    var didSelectAppearanceSettingClosure: ((TotalAmountViewSetting) throws -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, calendar: Calendar, appearanceSettings: [TotalAmountViewSetting], selectedAppearanceSetting: TotalAmountViewSetting) {
        self.appearanceSettings = appearanceSettings
        self.selectedAppearanceSetting = selectedAppearanceSetting
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
    private var appearanceSettingTableViewCellControllers: [TotalAmountViewSettingTableViewCellController]? {
        let cellControllers = sectionController.cellControllers
        let languageCellControllers = cellControllers as? [TotalAmountViewSettingTableViewCellController]
        return languageCellControllers
    }
    private func appearanceSettingTableViewCellController(_ appearanceSetting: TotalAmountViewSetting) -> TotalAmountViewSettingTableViewCellController? {
        let appearanceSettingTableViewCellController = appearanceSettingTableViewCellControllers?.first(where: { $0.appearanceSetting == appearanceSetting })
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
        backClosure?()
    }
    
    private func didSelectAppearanceType(_ totalAmountViewSetting: TotalAmountViewSetting) {
//        guard let didSelectAppearanceSettingClosure = didSelectAppearanceSettingClosure else { return }
//        guard selectedAppearanceSetting != appearanceType else { return }
//        do {
//            try didSelectAppearanceSettingClosure(appearanceType)
//            let currentSelectedCellController = appearanceSettingTableViewCellController(selectedAppearanceSetting)
//            currentSelectedCellController?.setIsSelected(false)
//            let selectedCellController = appearanceSettingTableViewCellController(appearanceType)
//            selectedCellController?.setIsSelected(true)
//            selectedAppearanceSetting = appearanceType
//            localizer.setLocale(locale)
//            appearanceTypeNameLocalizer.changeLocale(locale)
//            setContent()
//            tableViewController.reload()
//        } catch { }
    }
    
    // MARK: Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "SelectAppearanceScreenStrings")
        return localizer
    }()
    
    private lazy var appearanceTypeNameLocalizer: TotalAmountViewSettingNameLocalizer = {
        let localizer = TotalAmountViewSettingNameLocalizer(locale: locale)
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        localizer.setLocale(locale)
        appearanceTypeNameLocalizer.changeLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var cellControllers: [AUITableViewCellController] = []
        for appearanceSetting in appearanceSettings {
            let isSelected = appearanceSetting == selectedAppearanceSetting
            let cellController = TotalAmountViewSettingTableViewCellController(appearance: appearance, appearanceSetting: appearanceSetting, isSelected: isSelected, appearanceTypeNameLocalizer: appearanceTypeNameLocalizer)
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
            cellController.didSelectClosure = { [weak self] in
                guard let self = self else { return }
                self.didSelectAppearanceType(appearanceSetting)
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
