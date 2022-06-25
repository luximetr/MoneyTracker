//
//  CategoryColorHorizontalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 19.04.2022.
//

import UIKit
import AUIKit

class CategoryColorHorizontalPickerController: AUIEmptyViewController {
    
    // MARK: - Delegations
    
    var didSelectColorClosure: ((CategoryColor) -> Void)?
    
    // MARK: - Data
    
    private var colors: [CategoryColor] = []
    var selectedColor: CategoryColor?
    var appearance: Appearance
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.appearance = appearance
        super.init()
    }
    
    // MARK: - View
    
    var pickerView: ColorHorizontalPickerView {
        set { view = newValue }
        get { return view as! ColorHorizontalPickerView }
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        collectionController.collectionView = pickerView.collectionView
        reloadCollectionController()
    }
    
    override func unsetupView() {
        super.unsetupView()
        collectionController.collectionView = nil
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        pickerView.setAppearance(appearance)
        colorCellControllers.forEach { $0.uiColor = uiColorProvider.getUIColor(categoryColor: $0.color, appearance: appearance) }
    }
    
    // MARK: - Configuration
    
    func setColors(_ colors: [CategoryColor], selectedColor: CategoryColor) {
        self.colors = colors
        self.selectedColor = selectedColor
        reloadCollectionController()
    }
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    private func reloadCollectionController() {
        guard let selectedColor = selectedColor else { return }
        let cellControllers = colors.map { createColorCellController(color: $0, isSelected: selectedColor == $0) }
        selectedColorCellController = cellControllers.first(where: { selectedColor == $0.color })
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    private func createColorCellController(color: CategoryColor, isSelected: Bool) -> ColorCellController {
        let uiColor = uiColorProvider.getUIColor(categoryColor: color, appearance: appearance)
        let cellController = ColorCellController(color: color, uiColor: uiColor, isSelected: isSelected)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.pickerView.createColorCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.pickerView.getColorCellSize()
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let cellController = cellController else { return }
            self?.didSelectColorCellController(cellController)
        }
        return cellController
    }
    
    private var colorCellControllers: [ColorCellController] {
        return sectionController.cellControllers.compactMap { $0 as? ColorCellController }
    }
    
    private weak var selectedColorCellController: ColorCellController?
    
    private func didSelectColorCellController(_ cellController: ColorCellController) {
        selectedColorCellController?.setSelected(false, animated: true)
        cellController.setSelected(true, animated: true)
        selectedColorCellController = cellController
        selectedColor = cellController.color
        didSelectColorClosure?(cellController.color)
    }
}
