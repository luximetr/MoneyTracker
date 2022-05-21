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
    
    private(set) var appearance: Appearance
    private(set) var selectedCategory: Category?
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    
    // MARK: - View
    
    var categoryHorizontalPickerView: CategoryHorizontalPickerView {
        set { view = newValue }
        get { return view as! CategoryHorizontalPickerView }
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "CategoryHorizontalPickerStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: MyLocale) {
        super.changeLocale(locale)
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        categoryHorizontalPickerView.changeAppearance(appearance)
        categoriesCellControllers.forEach { $0.setAppearance(appearance) }
        addCellController?.setAppearance(appearance)
    }
    
    // MARK: - Initializer
    
    init(locale: MyLocale, appearance: Appearance) {
        self.appearance = appearance
        super.init(locale: locale)
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
    
    private let sectionController = AUIEmptyCollectionViewSectionController()
    
    func showOptions(categories: [Category]) {
        var cellControllers = createItemCellControllers(categories: categories)
        let text = localizer.localizeText("add")
        let addCellController = createAddCellController(text: text)
        cellControllers.append(addCellController)
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    func setSelectedCategory(_ category: Category?) {
        if let selectedCategory = selectedCategory {
            showCategoryDeselected(selectedCategory)
        }
        if let category = category {
            showCategorySelected(category)
        }
        self.selectedCategory = category
    }
    
    // MARK: - Item cell controller - Create
    
    private func createItemCellControllers(categories: [Category]) -> [AUICollectionViewCellController] {
        return categories.map { createItemCellController(category: $0, isSelected: $0.id == selectedCategory?.id) }
    }
    
    private func createItemCellController(category: Category, isSelected: Bool) -> AUICollectionViewCellController {
        let cellController = CategoryHorizontalPickerItemCellController(category: category, isSelected: isSelected, appearance: appearance)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryHorizontalPickerView.categoryCollectionViewCell(indexPath: indexPath, category: category, isSelected: isSelected)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.categoryHorizontalPickerView.categoryCollectionViewCellSize()
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectCategoryCell(category)
        }
        return cellController
    }
    
    private var categoriesCellControllers: [CategoryHorizontalPickerItemCellController] {
        return sectionController.cellControllers.compactMap { $0 as? CategoryHorizontalPickerItemCellController }
    }
    
    private func createAddCellController(text: String) -> AddCollectionViewCellController {
        let cellController = AddCollectionViewCellController(appearance: appearance, text: text)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryHorizontalPickerView.addCollectionViewCell(indexPath: indexPath)
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
    
    private var addCellController: AddCollectionViewCellController? {
        return sectionController.cellControllers.first(where: { $0 is AddCollectionViewCellController }) as? AddCollectionViewCellController
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
