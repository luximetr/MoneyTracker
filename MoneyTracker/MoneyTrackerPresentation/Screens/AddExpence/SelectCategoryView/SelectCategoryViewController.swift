//
//  SelectCategoryViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class SelectCategoryViewController: AUIEmptyViewController {
    
    // MARK: Data
    
    var categories: [Category] = []
    
    var selectedCategory: Category? {
        guard let componentController = pickerViewController.selectedItemController(atComponentController: componentController) else { return nil }
        guard let categoryTitlePickerViewItemController = componentController as? CategoryTitlePickerViewItemController else { return nil }
        let category = categoryTitlePickerViewItemController.category
        return category
    }
    
    // MARK:
    
    private let pickerViewController = AUIEmptyTitlePickerViewController()
    private let componentController = AUIEmptyTitlePickerViewComponentController()
    private var categoriesItemControllers: [CategoryTitlePickerViewItemController]? {
        let categoriesItemControllers = componentController.itemControllers as? [CategoryTitlePickerViewItemController]
        return categoriesItemControllers
    }
    private func categoryItemController(_ category: Category) -> CategoryTitlePickerViewItemController? {
        let categoryItemController = categoriesItemControllers?.first(where: { $0.category.id == category.id })
        return categoryItemController
    }
    
    // MARK: SelectCategoryView
  
    var selectCategoryView: SelectCategoryView? {
        set { view = newValue }
        get { return view as? SelectCategoryView }
    }
  
    override func setupView() {
        super.setupView()
        setupSelectCategoryView()
    }
    
    func setupSelectCategoryView() {
        pickerViewController.pickerView = selectCategoryView?.pickerView
        reload()
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupSelectCategoryView()
    }
  
    func unsetupSelectCategoryView() {
        pickerViewController.pickerView = nil
    }
    
    // MARK: Reload
    
    func reload() {
        var itemControllers: [AUITitlePickerViewItemController] = []
        for category in categories {
            let itemController = CategoryTitlePickerViewItemController(category: category)
            itemControllers.append(itemController)
        }
        componentController.titleItemControllers = itemControllers
        pickerViewController.titleComponentControllers = [componentController]
    }
    
    // MARK: Events
    
    func selectCategory(_ category: Category) {
        guard let itemController = categoryItemController(category) else { return }
        pickerViewController.selectItemController(itemController, atComponentController: componentController, animated: false)
    }
    
}
}

private final class CategoryTitlePickerViewItemController: AUITitlePickerViewItemController {
    
    // MARK: Data
    
    let category: Category
    
    // MARK: Initializer
    
    init(category: Category) {
        self.category = category
    }
    
    // MARK: AUITitlePickerViewItemController
    
    var title: String? {
        return category.name
    }
    
    var attributedTitle: NSAttributedString? {
        return nil
    }
    
    func didSelect() {
        
    }
}
