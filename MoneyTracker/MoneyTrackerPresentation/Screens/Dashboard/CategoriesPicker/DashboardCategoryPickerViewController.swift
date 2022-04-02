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
        categoryPickerView?.addExpenseButton.addTarget(self, action: #selector(addExpenseButtonTouchUpInsideEventAction), for: .touchUpInside)
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
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "DashboardCategoryPickerStrings")
        return localizer
    }()
    
    private func setContent() {
        categoryPickerView?.titleLabel.text = localizer.localizeText("title")
        categoryPickerView?.addExpenseButton.setTitle(localizer.localizeText("addExpense"), for: .normal)
        setCollectionControllerContent()
    }
    
    private func setCollectionControllerContent() {
        var cellControllers: [AUICollectionViewCellController] = []
        for category in categories {
            let cellController = createCategoryCellController(category: category)
            cellControllers.append(cellController)
        }
        let addCellController = createAddCellController(text: localizer.localizeText("add"))
        cellControllers.append(addCellController)
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
    
    private func createAddCellController(text: String) -> CategoryHorizontalPickerController.AddCollectionViewCellController {
        let cellController = CategoryHorizontalPickerController.AddCollectionViewCellController(text: text)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryPickerView!.addCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.categoryPickerView!.addCollectionViewCellSize(CategoryHorizontalPickerController.AddCollectionViewCellController.text(text))
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.addCategory()
        }
        return cellController
    }
    
    // MARK: Events
    
    func addCategory(_ category: Category) {
        categories.append(category)
        setContent()
    }
    
    func editCategory(_ category: Category) {
        guard let firstIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[firstIndex] = category
        setContent()
    }
    
    func deleteCategory(_ category: Category) {
        guard let firstIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories.remove(at: firstIndex)
        setContent()
    }
    
    func orderCategories(_ categories: [Category]) {
        self.categories = categories
        setContent()
    }
    
    var addExpenseClosure: (() -> Void)?
    @objc private func addExpenseButtonTouchUpInsideEventAction() {
        addExpenseClosure?()
    }
    
    var selectCategoryClosure: ((Category) -> Void)?
    private func didSelectCategoryCellController(_ categoryCellController: CategoryHorizontalPickerItemCellController) {
        let category = categoryCellController.category
        selectCategoryClosure?(category)
    }
    
    var addCategoryClosure: (() -> Void)?
    private func addCategory() {
        addCategoryClosure?()
    }
    
}
}
