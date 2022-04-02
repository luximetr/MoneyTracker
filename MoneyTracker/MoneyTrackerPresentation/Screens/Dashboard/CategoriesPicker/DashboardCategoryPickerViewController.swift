//
//  DashboardCategoryPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class CategoryPickerViewController: AUIEmptyViewController {
    
    // MARK: Data

    var categories: [Category] = []
    
    // MARK: Initializer
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: CategoryPickerView
  
    var categoryPickerView: CategoryPickerView? {
        set { view = newValue }
        get { return view as? CategoryPickerView }
    }
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
  
    override func setupView() {
        super.setupView()
        setupCategoryPickerView()
    }
    
    func setupCategoryPickerView() {
        categoryPickerView?.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        collectionController.collectionView = categoryPickerView?.collectionView
        setContent()
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupCategoryPickerView()
    }
  
    func unsetupCategoryPickerView() {
        collectionController.collectionView = nil
    }
    
    // MARK: Content
    
    private func setContent() {
        categoryPickerView?.titleLabel.text = "Add expense for category"
        categoryPickerView?.addButton.setTitle("Add expense", for: .normal)
        setCollectionControllerContent()
    }
    
    private func setCollectionControllerContent() {
        var cellControllers: [AUICollectionViewCellController] = []
        for category in categories {
            let cellController = createCategoryCellController(category: category)
            cellControllers.append(cellController)
        }
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    private func createCategoryCellController(category: Category) -> CategoryHorizontalPickerItemCellController {
        let cellController = CategoryHorizontalPickerItemCellController(category: category, isSelected: false)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryPickerView!.categoryCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self, cellController] in
            guard let self = self else { return .zero }
            let category = cellController.category
            return self.categoryPickerView!.categoryCollectionViewCellSize(name: category.name)
        }
        cellController.didSelectClosure = { [weak self, cellController] in
            guard let self = self else { return }
            self.didSelectCategoryCellController(cellController)
        }
        return cellController
    }
    
    // MARK: Events
    
    func addCategory(_ category: Category) {
        categories.append(category)
        setContent()
    }
    
    var addCategoryClosure: (() -> Void)?
    @objc private func addButtonTouchUpInsideEventAction() {
        addCategoryClosure?()
    }
    
    var selectCategoryClosure: ((Category) -> Void)?
    private func didSelectCategoryCellController(_ categoryCellController: CategoryHorizontalPickerItemCellController) {
        let category = categoryCellController.category
        selectCategoryClosure?(category)
    }
}
}
