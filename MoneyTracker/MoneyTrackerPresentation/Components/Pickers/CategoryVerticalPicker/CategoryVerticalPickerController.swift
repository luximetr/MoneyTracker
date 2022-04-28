//
//  CategoryVerticalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import Foundation
import AUIKit
import UIKit

class CategoryVerticalPickerController: EmptyViewController {
    
    // MARK: - Delegations
    
    var didTapOnAddClosure: (() -> Void)?
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    private var categories: [Category] = []
    
    // MARK: - Initializer
    
    init(appearance: Appearance, language: Language) {
        self.appearance = appearance
        super.init(language: language)
    }
    
    // MARK: - Language
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "CategoryVerticalPickerStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        
    }
    
    // MARK: - View
    
    var pickerView: CategoryVerticalPickerView? {
        set { view = newValue }
        get { return view as? CategoryVerticalPickerView }
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        setupTableViewController()
    }
    
    override func unsetupView() {
        super.unsetupView()
        tableViewController.view = nil
    }
    
    // MARK: - TableViewController
    
    private let tableViewController = AUIEmptyTableViewController()
    
    private func setupTableViewController() {
        tableViewController.tableView = pickerView?.tableView
        
    }
    
    // MARK: - Categories
    
    func setCategories(_ categories: [Category]) {
        self.categories = categories
        showCategories(categories)
    }
    
    private let sectionController = AUIEmptyTableViewSectionController()
    
    private func showCategories(_ categories: [Category]) {
        var cellControllers: [AUITableViewCellController] = []
        let categoriesCellControlers = createCategoriesCells(categories)
        cellControllers.append(contentsOf: categoriesCellControlers)
        let addCellController = createAddCellController()
        cellControllers.append(addCellController)
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
        tableViewController.reload()
    }
    
    // MARK: - Selected category
    
    private(set) var selectedCategory: Category?
    
    func setSelectedCategory(_ category: Category?) {
        self.selectedCategory = category
        if let category = category {
            showCategorySelected(categoryId: category.id)
        }
    }
    
    // MARK: - Category cell
    
    private func createCategoriesCells(_ categories: [Category]) -> [CategoryCellController] {
        return categories.map { createCategoryCell($0) }
    }
    
    private func createCategoryCell(_ category: Category) -> CategoryCellController {
        let cellController = CategoryCellController(appearance: appearance, category: category)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            return self?.pickerView?.createCategoryCell(indexPath: indexPath) ?? UITableViewCell()
        }
        cellController.estimatedHeightClosure = { [weak self] in
            return self?.pickerView?.getCategoryCell() ?? 0
        }
        cellController.heightClosure = { [weak self] in
            return self?.pickerView?.getCategoryCell() ?? 0
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectCategoryCell(categoryId: category.id)
        }
        return cellController
    }
    
    private func findIndexPath(categoryId: String) -> IndexPath? {
        let index = sectionController.cellControllers.firstIndex(where: { cellController in
            let categoryCellController = cellController as? CategoryCellController
            return categoryCellController?.category.id == categoryId
        })
        guard let index = index else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    private func showCategorySelected(categoryId: String) {
        guard let indexPath = findIndexPath(categoryId: categoryId) else { return }
        pickerView?.scrollToCell(at: indexPath)
    }
    
    private func didSelectCategoryCell(categoryId: String) {
        guard let newSelectedCategory = categories.first(where: { $0.id == categoryId }) else { return }
        showCategorySelected(categoryId: categoryId)
        self.selectedCategory = newSelectedCategory
    }
    
    // MARK: - Add cell
    
    private func createAddCellController() -> AddCellController {
        let cellController = AddCellController(title: localizer.localizeText("add"))
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let cell = self?.pickerView?.createAddCell(indexPath: indexPath) else { return UITableViewCell() }
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            return self?.pickerView?.getAddCellHeight() ?? 0
        }
        cellController.heightClosure = { [weak self] in
            return self?.pickerView?.getAddCellHeight() ?? 0
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectAddCell()
        }
        return cellController
    }
    
    private func showAddCellSelected() {
        let index = sectionController.cellControllers.firstIndex(where: { $0 is AddCellController })
        guard let index = index else { return }
        pickerView?.scrollToCell(at: IndexPath(row: index, section: 0))
    }
    
    private func didSelectAddCell() {
        showAddCellSelected()
        didTapOnAddClosure?()
    }
}
