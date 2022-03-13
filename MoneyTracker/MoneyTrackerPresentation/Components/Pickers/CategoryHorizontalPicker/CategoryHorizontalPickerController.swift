//
//  CategoryHorizontalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class CategoryHorizontalPickerController: AUIEmptyViewController {
    
    // MARK: - Delegations
    
    var didSelectCategoryClosure: ((Category) -> Void)?
    
    // MARK: - Data
    
    private var selectedCategory: Category?
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    
    // MARK: - View
    
    var categoryHorizontalPickerView: CategoryHorizontalPickerView {
        set { view = newValue }
        get { return view as! CategoryHorizontalPickerView }
    }
    
    // MARK: - View - Setup
}
