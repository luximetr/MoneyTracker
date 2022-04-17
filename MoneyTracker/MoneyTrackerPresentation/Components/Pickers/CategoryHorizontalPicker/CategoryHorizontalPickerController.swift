//
//  CategoryHorizontalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class CategoryHorizontalPickerController: EmptyViewController {
    
    // MARK: - Delegations
    
    var didSelectCategoryClosure: ((Category) -> Void)?
    
    // MARK: - Data
    
    var selectedCategory: Category?
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    
    // MARK: - View
    
    var categoryHorizontalPickerView: CategoryHorizontalPickerView {
        set { view = newValue }
        get { return view as! CategoryHorizontalPickerView }
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "CategoryHorizontalPickerStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        collectionController.collectionView = categoryHorizontalPickerView.collectionView
    }
    
    override func unsetupView() {
        super.unsetupView()
        collectionController.collectionView = nil
    }
    
    // MARK: - Configuration
    
    func showOptions(categories: [Category], selectedCategory: Category) {
        self.selectedCategory = selectedCategory
        let sectionController = AUIEmptyCollectionViewSectionController()
        var cellControllers = createItemCellControllers(categories: categories, selectedCategory: selectedCategory)
        let text = localizer.localizeText("add")
        let addCellController = createAddCellController(text: text)
        cellControllers.append(addCellController)
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
        if let cellController = findCellController(forCategoryId: selectedCategory.id), let indexPath = collectionController.indexPathForCellController(cellController) {
            categoryHorizontalPickerView.collectionViewScrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Item cell controller - Create
    
    private func createItemCellControllers(categories: [Category], selectedCategory: Category) -> [AUICollectionViewCellController] {
        return categories.map { createItemCellController(category: $0, isSelected: $0.id == selectedCategory.id) }
    }
    
    private func createItemCellController(category: Category, isSelected: Bool) -> AUICollectionViewCellController {
        let cellController = CategoryHorizontalPickerItemCellController(category: category, isSelected: isSelected)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryHorizontalPickerView.createItemCell(indexPath: indexPath, category: category, isSelected: isSelected)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.categoryHorizontalPickerView.getItemCellSize()
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectCategoryCell(category)
        }
        return cellController
    }
    
    private func createAddCellController(text: String) -> AddCollectionViewCellController {
        let cellController = AddCollectionViewCellController(text: text)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryHorizontalPickerView.createAddCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.categoryHorizontalPickerView.addCollectionViewCellSize(AddCollectionViewCellController.text(text))
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.addCategory()
        }
        return cellController
    }
    
    // MARK: - Item cell controller - Find
    
    private func findCellController(forCategoryId categoryId: CategoryId) -> CategoryHorizontalPickerItemCellController? {
        let cellControllers = collectionController.sectionControllers.map({ $0.cellControllers }).reduce([], +).compactMap { $0 as? CategoryHorizontalPickerItemCellController }
        let foundCellController = cellControllers.first(where: { $0.category.id == categoryId })
        return foundCellController
    }
    
    // MARK: - Item cell controller - Update
    
    private func showCategorySelected(_ category: Category) {
        guard let cellController = findCellController(forCategoryId: category.id) else { return }
        cellController.isSelected = true
    }
    
    private func showCategoryDeselected(_ category: Category) {
        guard let cellController = findCellController(forCategoryId: category.id) else { return }
        cellController.isSelected = false
    }
    
    // MARK: - Item cell controller - Actions
    
    private func didSelectCategoryCell(_ category: Category) {
        guard let selectedCategory = selectedCategory else { return }
        showCategoryDeselected(selectedCategory)
        self.selectedCategory = category
        showCategorySelected(category)
        didSelectCategoryClosure?(category)
    }
    
    var addCategoryClosure: (() -> Void)?
    private func addCategory() {
        addCategoryClosure?()
    }
}
