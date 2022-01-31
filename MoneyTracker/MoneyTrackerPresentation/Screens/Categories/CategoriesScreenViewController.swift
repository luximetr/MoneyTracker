//
//  CategoriesScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: View
    
    override func loadView() {
        view = CategoriesScreenView()
    }
    
    private var categoriesScreenView: CategoriesScreenView! {
        return view as? CategoriesScreenView
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "CategoriesScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewController()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = categoriesScreenView.tableView
        let sectionController = AUIEmptyTableViewSectionController()
        var cellControllers: [AUITableViewCellController] = []
        for i in 1...10 {
            let cellController = AUIClosuresTableViewCellController()
            cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UITableViewCell() }
                let cell = self.categoriesScreenView.categoryTableViewCell(indexPath)
                return cell!
            }
            cellController.estimatedHeightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return 76
            }
            cellController.heightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return 76
            }
            cellController.didSelectClosure = { [weak self] in
                print(i)
            }
            cellControllers.append(cellController)
        }
        
        let addCategoryCellController = AUIClosuresTableViewCellController()
        addCategoryCellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.categoriesScreenView.addCategoryTableViewCell(indexPath)!
            cell._textLabel.text = self.localizer.localizeText("addCategory")
            return cell
        }
        addCategoryCellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return 76
        }
        addCategoryCellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return 76
        }
        addCategoryCellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAddCategory()
        }
        cellControllers.append(addCategoryCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    // MARK: Events
    
    private func didSelectAddCategory() {
        print("add category")
    }
    
}
