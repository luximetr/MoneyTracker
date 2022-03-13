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
