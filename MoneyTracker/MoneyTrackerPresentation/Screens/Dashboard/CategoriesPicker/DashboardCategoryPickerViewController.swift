//
//  DashboardCategoryPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class CategoryPickerViewController: EmptyViewController {
    
    // MARK: Data

    private(set) var appearance: Appearance
    var categories: [Category] = []
    
    // MARK: Initializer
    
    init(locale: Locale, appearance: Appearance, categories: [Category]) {
        self.appearance = appearance
        self.categories = categories
        super.init(locale: locale)
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
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "DashboardCategoryPickerStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        localizer.setLocale(locale)
        setContent()
    }
    
    private func setContent() {
        categoryPickerView?.titleLabel.text = localizer.localizeText("title")
        categoryPickerView?.addExpenseButton.setTitle(localizer.localizeText("addExpense"), for: .normal)
        categoryPickerView?.layoutSubviews()
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
    
    private func createCategoryCellController(category: Category) -> CategoryCellController {
        let cellController = CategoryCellController(appearance: appearance, category: category)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.categoryPickerView!.categoryCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self, weak cellController] in
            guard let self = self else { return .zero }
            guard let cellController = cellController else { return .zero }
            let category = cellController.category
            return self.categoryPickerView!.categoryCollectionViewCellSize(name: category.name)
        }
        cellController.didSelectClosure = { [weak self, cellController] in
            guard let self = self else { return }
            self.didSelectCategoryCellController(cellController)
        }
        return cellController
    }
    
    private var categoriesCellControllers: [CategoryCellController] {
        return sectionController.cellControllers.compactMap { $0 as? CategoryCellController }
    }
    
    private func findCellController(category: Category) -> CategoryCellController? {
        return sectionController.cellControllers.first(where: {
            return ($0 as? CategoryCellController)?.category.id == category.id
        }) as? CategoryCellController
    }
    
    private func createAddCellController(text: String) -> CategoryHorizontalPickerController.AddCollectionViewCellController {
        let cellController = CategoryHorizontalPickerController.AddCollectionViewCellController(appearance: appearance, text: text)
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
    
    private var addCellController: CategoryHorizontalPickerController.AddCollectionViewCellController? {
        return sectionController.cellControllers.first(where: { $0 is CategoryHorizontalPickerController.AddCollectionViewCellController }) as? CategoryHorizontalPickerController.AddCollectionViewCellController
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        categoryPickerView?.setAppearance(appearance)
        categoriesCellControllers.forEach { $0.changeAppearance(appearance) }
        addCellController?.setAppearance(appearance)
    }
    
    // MARK: Events
    
    func addCategory(_ category: Category) {
        categories.append(category)
        setContent()
    }
    
    func addCategories(_ categories: [Category]) {
        guard !categories.isEmpty else { return }
        self.categories.append(contentsOf: categories)
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
        guard let categoryCellController = findCellController(category: category) else { return }
        collectionController.deleteCellController(categoryCellController, completion: nil)
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
    private func didSelectCategoryCellController(_ categoryCellController: CategoryCellController) {
        let category = categoryCellController.category
        selectCategoryClosure?(category)
    }
    
    var addCategoryClosure: (() -> Void)?
    private func addCategory() {
        addCategoryClosure?()
    }
    
}
}
