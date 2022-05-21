//
//  SelectAppearanceScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import UIKit
import AUIKit

final class SelectAppearanceScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Currency - Data
    
    private let appearanceSettings: [AppearanceSetting]
    private var selectedAppearanceSetting: AppearanceSetting
    var backClosure: (() -> Void)?
    var didSelectAppearanceSettingClosure: ((AppearanceSetting) throws -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, appearanceSettings: [AppearanceSetting], selectedAppearanceSetting: AppearanceSetting) {
        self.appearanceSettings = appearanceSettings
        self.selectedAppearanceSetting = selectedAppearanceSetting
        super.init(appearance: appearance, locale: locale)
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
    private var appearanceSettingTableViewCellControllers: [AppearanceSettingTableViewCellController]? {
        let cellControllers = sectionController.cellControllers
        let languageCellControllers = cellControllers as? [AppearanceSettingTableViewCellController]
        return languageCellControllers
    }
    private func appearanceSettingTableViewCellController(_ appearanceSetting: AppearanceSetting) -> AppearanceSettingTableViewCellController? {
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
    
    private func didSelectAppearanceType(_ appearanceType: AppearanceSetting) {
        guard let didSelectAppearanceSettingClosure = didSelectAppearanceSettingClosure else { return }
        guard selectedAppearanceSetting != appearanceType else { return }
        do {
            try didSelectAppearanceSettingClosure(appearanceType)
            let currentSelectedCellController = appearanceSettingTableViewCellController(selectedAppearanceSetting)
            currentSelectedCellController?.setIsSelected(false)
            let selectedCellController = appearanceSettingTableViewCellController(appearanceType)
            selectedCellController?.setIsSelected(true)
            selectedAppearanceSetting = appearanceType
            localizer.changeLocale(locale)
            appearanceTypeNameLocalizer.changeLocale(locale)
            setContent()
            tableViewController.reload()
        } catch { }
    }
    
    // MARK: Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "SelectAppearanceScreenStrings")
        return localizer
    }()
    
    private lazy var appearanceTypeNameLocalizer: AppearanceSettingNameLocalizer = {
        let localizer = AppearanceSettingNameLocalizer(locale: locale)
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        localizer.changeLocale(locale)
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
            let cellController = AppearanceSettingTableViewCellController(appearance: appearance, appearanceSetting: appearanceSetting, isSelected: isSelected, appearanceTypeNameLocalizer: appearanceTypeNameLocalizer)
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
    
    private var appearancesSettingCells: [AppearanceSettingTableViewCellController] {
        return sectionController.cellControllers.compactMap { $0 as? AppearanceSettingTableViewCellController }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        appearancesSettingCells.forEach { $0.setAppearance(appearance) }
    }
}
