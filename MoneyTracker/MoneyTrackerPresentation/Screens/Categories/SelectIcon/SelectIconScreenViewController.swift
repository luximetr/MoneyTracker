//
//  SelectIconScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.04.2022.
//

import AUIKit
import UIKit

class SelectIconScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private let iconNames: [String]
    private let color: CategoryColor
    
    // MARK: - Delegations
    
    var didSelectIconClosure: ((String) -> Void)?

    // MARK: - Life cycle
    
    init(appearance: Appearance, language: Language, iconNames: [String], color: CategoryColor) {
        self.iconNames = iconNames
        self.color = color
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionController()
        setContent()
    }
    
    // MARK: - Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "SelectIconScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
    // MARK: - Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        let iconCellBackgroundColor = uiColorProvider.getUIColor(categoryColor: color, appearance: appearance)
        iconCellControllers.forEach { $0.backgroundColor = iconCellBackgroundColor }
    }
    
    // MARK: - Icons
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    private func setupCollectionController() {
        collectionController.collectionView = screenView.collectionView
        let cellControllers = iconNames.map { createCellController(iconName: $0) }
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    private func createCellController(iconName: String) -> IconCellController {
        let iconColor = uiColorProvider.getUIColor(categoryColor: color, appearance: appearance)
        let cellController = IconCellController(iconName: iconName, backgroundColor: iconColor)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.screenView.createIconCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.screenView.getIconCellSize()
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectIconCellController(iconName: iconName)
        }
        return cellController
    }
    
    private var iconCellControllers: [IconCellController] {
        return sectionController.cellControllers.compactMap { $0 as? IconCellController }
    }
    
    private func didSelectIconCellController(iconName: String) {
        didSelectIconClosure?(iconName)
    }
}
