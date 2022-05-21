//
//  CategoriesListScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesListScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private var categories: [Category]
    var backClosure: (() -> Void)?
    var editCategoryClosure: ((Category) -> Void)?
    var deleteCategoryClosure: ((Category) throws -> Void)?
    var orderCategoriesClosure: (([Category]) throws -> Void)?
    var addCategoryClosure: (() -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: MyLocale, categories: [Category]) {
        self.categories = categories
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: - View
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private let tableViewController = AUIClosuresTableViewController()
    private let categoriesSectionController = AUIEmptyTableViewSectionController()
    private var categoriesCellControllers: [CategoryTableViewCellController]? {
        let categoriesCellControllers = categoriesSectionController.cellControllers as? [CategoryTableViewCellController]
        return categoriesCellControllers
    }
    private func categoryCellController(_ category: Category) -> CategoryTableViewCellController? {
        let categoryCellController = categoriesCellControllers?.first(where: { $0.category.id == category.id })
        return categoryCellController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
        tableViewController.dragInteractionEnabled = true
        tableViewController.targetIndexPathForMoveFromRowAtClosure = { sourceCellController, destinationCellController in
            return destinationCellController
        }
        tableViewController.moveCellControllerClosure = { [weak self] sourceCellController, destinationCellController in
            guard let self = self else { return }
            guard let sourceCategory = (sourceCellController as? CategoryTableViewCellController)?.category else { return }
            guard let destinationCategory = (destinationCellController as? CategoryTableViewCellController)?.category else { return }
            guard let sourceCategoryIndex = self.categories.firstIndex(of: sourceCategory) else { return }
            guard let destinationCategoryIndex = self.categories.firstIndex(of: destinationCategory) else { return }
            self.categories.remove(at: sourceCategoryIndex)
            self.categories.insert(sourceCategory, at: destinationCategoryIndex)
            do {
                try self.orderCategoriesClosure?(self.categories)
            } catch {
                self.categories.remove(at: destinationCategoryIndex)
                self.categories.insert(sourceCategory, at: sourceCategoryIndex)
                self.setTableViewContent()
            }
        }
    }
    
    // MARK: - Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func addButtonTouchUpInsideEventAction() {
        addCategoryClosure?()
    }
    
    private func didSelectCategory(_ category: Category) {
        editCategoryClosure?(category)
    }
    
    private func didSelectAddCategory() {
        addCategoryClosure?()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        let cellController = createCategoryTableViewCellController(category: category)
        tableViewController.insertCellControllerAtSectionEndAnimated(categoriesSectionController, cellController: cellController, .automatic, completion: nil)
    }
    
    func editCategory(_ category: Category) {
        guard let firstIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[firstIndex] = category
        guard let categoryCellController = self.categoryCellController(category) else { return }
        categoryCellController.editCategory(category)
    }
    
    // MARK: - Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "CategoriesListScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var categoriesCellControllers: [AUITableViewCellController] = []
        for category in categories {
            let cellController = createCategoryTableViewCellController(category: category)
            categoriesCellControllers.append(cellController)
        }
        categoriesSectionController.cellControllers = categoriesCellControllers
        tableViewController.sectionControllers = [categoriesSectionController]
        tableViewController.reload()
    }
    
    private func createCategoryTableViewCellController(category: Category) -> CategoryTableViewCellController {
        let cellController = CategoryTableViewCellController(category: category, appearance: appearance)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.categoryTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.screenView.categoryTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.screenView.categoryTableViewCellHeight()
            return height
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectCategory(cellController.category)
        }
        cellController.itemsForBeginningSessionClosure = { _ in
            return []
        }
        cellController.canMoveCellClosure = {
            return true
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let deleteAction = UIContextualAction(style: .destructive, title:  self.localizer.localizeText("delete"), handler: { contextualAction, view, success in
                do {
                    try self.deleteCategoryClosure?(category)
                    self.tableViewController.deleteCellControllerAnimated(cellController, .left) { finished in
                        success(true)
                    }
                } catch {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return cellController
    }
    
    private var categoryCellControllers: [CategoryTableViewCellController] {
        return categoriesSectionController.cellControllers.compactMap { $0 as? CategoryTableViewCellController }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        categoryCellControllers.forEach { $0.setAppearance(appearance) }
    }
    
}
