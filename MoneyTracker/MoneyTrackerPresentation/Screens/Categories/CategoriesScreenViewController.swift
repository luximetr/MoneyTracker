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
    var didDeleteCategoryClosure: ((Category) throws -> Void)?
    var didSelectAddCategoryClosure: (() -> Void)?
    var didSelectCategoryClosure: ((Category) -> Void)?
    var didSortCategoriesClosure: (([Category]) -> Void)?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.titleLabel.text = localizer.localizeText("title")
        setupTableViewController()
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "CategoriesScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
        tableViewController.targetIndexPathForMoveFromRowAtClosure = { sourceCellController, destinationCellController in
            if destinationCellController is CategoriesScreenAddCategoryTableViewCellController {
                return sourceCellController
            }
            return destinationCellController
        }
        tableViewController.moveCellControllerClosure = { [weak self] sourceCellController, destinationCellController in
            guard let self = self else { return }
            guard let category1 = (sourceCellController as? CategoriesScreenCategoryTableViewCellController)?.category else { return }
            guard let category2 = (destinationCellController as? CategoriesScreenCategoryTableViewCellController)?.category else { return }
            guard let i = self.categories.firstIndex(of: category1) else { return }
            guard let j = self.categories.firstIndex(of: category2) else { return }
            self.categories.swapAt(i, j)
            self.didSortCategoriesClosure?(self.categories)
        }
        tableViewController.dragInteractionEnabled = true
        let sectionController = AUIEmptyTableViewSectionController()
        var cellControllers: [AUITableViewCellController] = []
        for category in categories {
            let cellController = CategoriesScreenCategoryTableViewCellController(category: category)
            cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UITableViewCell() }
                let cell = self.screenView.categoryTableViewCell(indexPath)
                cell?.nameLabel.text = category.name
                return cell!
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
                self.didSelectCategory(category)
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
                        try self.didDeleteCategoryClosure?(category)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { finished in
                            success(true)
                        }
                    } catch {
                        success(false)
                    }
                })
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
            cellControllers.append(cellController)
        }
        
        let addCategoryCellController = createAddCategoryTableViewCellController()
        cellControllers.append(addCategoryCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    private func createAddCategoryTableViewCellController() -> CategoriesScreenAddCategoryTableViewCellController {
        let addCategoryCellController = CategoriesScreenAddCategoryTableViewCellController()
        addCategoryCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.addCategoryTableViewCell(indexPath)!
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
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectCategory(_ category: Category) {
        didSelectCategoryClosure?(category)
    }
    
    private func didSelectAddCategory() {
        didSelectAddCategoryClosure?()
    }
    
}
