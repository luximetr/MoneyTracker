//
//  CategoriesScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private var categories: [Category]
    var backClosure: (() -> Void)?
    var editCategoryClosure: ((Category) -> Void)?
    var deleteCategoryClosure: ((Category) throws -> Void)?
    var orderCategoriesClosure: (([Category]) throws -> Void)?
    var addCategoryClosure: (() -> Void)?
    
    func editCategory(_ category: Category) {
        guard let firstIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[firstIndex] = category
        guard let cellController = categoriesCellControllers?.first(where: { $0.category.id == category.id }) else { return }
        cellController.editCategory(category)
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        let cellController = createCategoryTableViewCellController(category: category)
        tableViewController.insertCellControllerAtSectionEndAnimated(categoriesSectionController, cellController: cellController, .automatic, completion: nil)
    }
    
    func updateCategories(_ categories: [Category]) {
        self.categories = categories
        setupTableViewController()
    }
    
    // MARK: Initializer
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: View
    
    private var screenView: CategoriesScreenView! {
        return view as? CategoriesScreenView
    }
    
    override func loadView() {
        view = CategoriesScreenView()
    }
    
    private let tableViewController = AUIClosuresTableViewController()
    private let categoriesSectionController = AUIEmptyTableViewSectionController()
    private var categoriesCellControllers: [CategoryTableViewCellController]? {
        return categoriesSectionController.cellControllers as? [CategoryTableViewCellController]
    }
    private let addCategorySectionController = AUIEmptyTableViewSectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
        tableViewController.dragInteractionEnabled = true
        tableViewController.targetIndexPathForMoveFromRowAtClosure = { sourceCellController, destinationCellController in
            if destinationCellController is AddTableViewCellController {
                return sourceCellController
            }
            return destinationCellController
        }
        tableViewController.moveCellControllerClosure = { [weak self] sourceCellController, destinationCellController in
            guard let self = self else { return }
            guard let sourceCategory = (sourceCellController as? CategoryTableViewCellController)?.category else { return }
            guard let destinationCategory = (destinationCellController as? CategoryTableViewCellController)?.category else { return }
            guard let sourceCategoryIndex = self.categories.firstIndex(of: sourceCategory) else { return }
            guard let destinationCategoryIndex = self.categories.firstIndex(of: destinationCategory) else { return }
            self.categories.swapAt(sourceCategoryIndex, destinationCategoryIndex)
            do {
                try self.orderCategoriesClosure?(self.categories)
            } catch {
                self.categories.swapAt(sourceCategoryIndex, destinationCategoryIndex)
                self.setTableViewContent()
            }
        }
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "CategoriesScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectCategory(_ category: Category) {
        editCategoryClosure?(category)
    }
    
    private func didSelectAddCategory() {
        addCategoryClosure?()
    }
    
    // MARK: Content
    
    func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    func setTableViewContent() {
        var categoriesCellControllers: [AUITableViewCellController] = []
        for category in categories {
            let cellController = createCategoryTableViewCellController(category: category)
            categoriesCellControllers.append(cellController)
        }
        categoriesSectionController.cellControllers = categoriesCellControllers
        
        var addCategoryCellControllers: [AUITableViewCellController] = []
        let addCategoryCellController = createAddCategoryTableViewCellController()
        addCategoryCellControllers.append(addCategoryCellController)
        addCategorySectionController.cellControllers = addCategoryCellControllers
        
        tableViewController.sectionControllers = [categoriesSectionController, addCategorySectionController]
        tableViewController.reload()
    }
    
    private func createCategoryTableViewCellController(category: Category) -> CategoryTableViewCellController {
        let cellController = CategoryTableViewCellController(category: category)
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
    
    private func createAddCategoryTableViewCellController() -> AddTableViewCellController {
        let addCategoryCellController = AddTableViewCellController()
        addCategoryCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.addCategoryTableViewCell(indexPath)
            cell._textLabel.text = self.localizer.localizeText("addCategory")
            return cell
        }
        addCategoryCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let estimatedHeight = self.screenView.addCategoryTableViewCellEstimatedHeight()
            return estimatedHeight
        }
        addCategoryCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            let height = self.screenView.addCategoryTableViewCellHeight()
            return height
        }
        addCategoryCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAddCategory()
        }
        addCategoryCellController.canMoveCellClosure = {
            return false
        }
        return addCategoryCellController
    }
    
}
