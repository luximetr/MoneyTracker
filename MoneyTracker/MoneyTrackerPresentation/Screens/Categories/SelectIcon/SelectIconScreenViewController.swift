//
//  SelectIconScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.04.2022.
//

import AUIKit
import UIKit

class SelectIconScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    private let iconColor: UIColor
    
    // MARK: - Delegations
    
    var didSelectIconClosure: ((String) -> Void)?

    // MARK: - Life cycle
    
    init(iconColor: UIColor) {
        self.iconColor = iconColor
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionController()
        setContent()
    }
    
    // MARK: - Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "SelectIconScreenStrings")
        return localizer
    }()
    
    // MARK: - Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: - Icons
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    
    private func setupCollectionController() {
        collectionController.collectionView = screenView.collectionView
        let iconNames = ["bag", "cart", "creditcard", "giftcard", "dollarsign.circle", "bitcoinsign.circle", "car", "car.fill", "airplane", "bus", "bus.fill", "tram", "tram.fill", "ferry", "ferry.fill"]
        let cellControllers = iconNames.map { createCellController(iconName: $0) }
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    private func createCellController(iconName: String) -> IconCellController {
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
    
    private func didSelectIconCellController(iconName: String) {
        didSelectIconClosure?(iconName)
    }
}
