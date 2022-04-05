//
//  ColorHorizontalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import UIKit
import AUIKit

final class ColorHorizontalPickerController: AUIEmptyViewController {
    
    // MARK: - Delegations
    
    var didSelectColorClosure: ((UIColor) -> Void)?
    
    // MARK: - Data
    
    private var colors: [UIColor] = []
    var selectedColor: UIColor?
    
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
    
    // MARK: - Configuration
    
    func setColors(_ colors: [UIColor], selectedColor: UIColor) {
        self.colors = colors
        self.selectedColor = selectedColor
        reloadCollectionController()
    }
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private let colorsComparator = UIColorComparator()
    
    private func reloadCollectionController() {
        guard let selectedColor = selectedColor else { return }
        let cellControllers = colors.map { createColorCellController(color: $0, isSelected: colorsComparator.findIsColorsEquals(selectedColor, $0)) }
        selectedColorCellController = cellControllers.first(where: { colorsComparator.findIsColorsEquals($0.color, selectedColor) })
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    private func createColorCellController(color: UIColor, isSelected: Bool) -> ColorCellController {
        let cellController = ColorCellController(color: color, isSelected: isSelected)
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
    
    private weak var selectedColorCellController: ColorCellController?
    
    private func didSelectColorCellController(_ cellController: ColorCellController) {
        selectedColorCellController?.setSelected(false, animated: true)
        cellController.setSelected(true, animated: true)
        selectedColorCellController = cellController
        selectedColor = cellController.color
        didSelectColorClosure?(cellController.color)
    }
}
