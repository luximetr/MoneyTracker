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
    private lazy var lastTickedY: CGFloat = {
        return (pickerView?.cellHeight ?? 0) / 2
    }()
    private let hapticFeedbackGenerator = UISelectionFeedbackGenerator()
    private var hapticFeedbackScrollListener: (() -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale) {
        self.appearance = appearance
        super.init(locale: locale)
    }
    
    // MARK: - Language
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "CategoryVerticalPickerStrings")
        return localizer
    }()
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        pickerView?.setAppearance(appearance)
        findCategoriesCellControllers().forEach { $0.setAppearance(appearance) }
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
        tableViewController.scrollViewDidEndDraggingClosure = { [weak self] willDecelerate in
            guard willDecelerate == false else { return }
            self?.scrollToNearestCategoryCell()
        }
        tableViewController.scrollViewDidEndDeceleratingClosure = { [weak self] in
            self?.scrollToNearestCategoryCell()
        }
        tableViewController.scrollViewDidScrollClosure = { [weak self] in
            self?.hapticFeedbackScrollListener?()
        }
        tableViewController.scrollViewWillBeginDraggingClosure = { [weak self] in
            self?.startHapticFeedbackScrollListener()
        }
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
    
    // MARK: - Category cell - Create
    
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
    
    // MARK: - Category cell - Find
    
    private func findIndexPath(categoryId: String) -> IndexPath? {
        let index = sectionController.cellControllers.firstIndex(where: { cellController in
            let categoryCellController = cellController as? CategoryCellController
            return categoryCellController?.category.id == categoryId
        })
        guard let index = index else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    private func findCategoriesCellControllers() -> [CategoryCellController] {
        return sectionController.cellControllers.compactMap { $0 as? CategoryCellController }
    }
    
    // MARK: - Category cell - Selection
    
    private func didSelectCategoryCell(categoryId: String) {
        guard let newSelectedCategory = categories.first(where: { $0.id == categoryId }) else { return }
        showCategorySelected(categoryId: categoryId)
        self.selectedCategory = newSelectedCategory
    }
    
    private func showCategorySelected(categoryId: String) {
        guard let indexPath = findIndexPath(categoryId: categoryId) else { return }
        scrollToCell(at: indexPath, useHapticFeedback: false)
    }
    
    private func scrollToNearestCategoryCell() {
        guard let indexPath = pickerView?.findNearestCellIndexPathUnderDivider() else { return }
        scrollToCell(at: indexPath, useHapticFeedback: true)
        guard let cellController = sectionController.cellControllers[safe: indexPath.row] else { return }
        guard let categoryId = (cellController as? CategoryCellController)?.category.id else { return }
        guard let category = categories.first(where: { $0.id == categoryId }) else { return }
        selectedCategory = category
    }
    
    private func scrollToCell(at indexPath: IndexPath, useHapticFeedback: Bool) {
        if useHapticFeedback {
            startHapticFeedbackScrollListener()
        } else {
            stopHapticFeedbackScrollListener()
        }
        pickerView?.scrollToCell(at: indexPath)
    }
    
    // MARK: - Add cell - Create
    
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
    
    // MARK: - Add cell - Selection
    
    private func didSelectAddCell() {
        didTapOnAddClosure?()
    }
    
    // MARK: - Haptic feedback - Scroll
    
    private func triggerScrollHapticFeedbackIfNeeded() {
        guard let pickerView = pickerView else { return }
        let cellHeight = pickerView.cellHeight
        let contentOffsetY = pickerView.tableView.contentOffset.y + pickerView.tableView.contentInset.top
        let selectedCellIndex = Int((contentOffsetY + cellHeight / 2) / cellHeight)
        let tickY = contentOffsetY + (cellHeight / 2)
        let selectedCellTickY = CGFloat(selectedCellIndex) * cellHeight + cellHeight / 2
        
        if abs(tickY - lastTickedY) >= cellHeight {
            lastTickedY = selectedCellTickY
            triggerHapticFeedback()
        }
    }
    
    private func triggerHapticFeedback() {
        hapticFeedbackGenerator.selectionChanged()
    }
    
    private func startHapticFeedbackScrollListener() {
        hapticFeedbackScrollListener = { [weak self] in
            self?.triggerScrollHapticFeedbackIfNeeded()
        }
    }
    
    private func stopHapticFeedbackScrollListener() {
        hapticFeedbackScrollListener = nil
    }
}
