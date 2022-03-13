//
//  AddExpenceScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

final class AddExpenseScreenViewController: AUIStatusBarScreenViewController, AUITextFieldControllerDidTapReturnKeyObserver {
    
    // MARK: Data
    
    private let categories: [Category]
    
    // MARK: Initializer
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddExpenseScreenStrings")
        return localizer
    }()
    
    // MARK: View
    
    private var addExpenseScreenView: AddExpenseScreenView {
        return view as! AddExpenseScreenView
    }
    
    override func loadView() {
        view = AddExpenseScreenView()
    }
    
    private let inputDateViewController = InputDateViewController()
    private let commentTextFieldController = AUIEmptyTextFieldController()
    private let inputAmountViewController = InputAmountViewController()
    private let selectCategoryViewController = SelectCategoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addExpenseScreenView.titleLabel.text = localizer.localizeText("title")
        inputDateViewController.inputDateView = addExpenseScreenView.inputDateView
        inputAmountViewController.inputAmountView = addExpenseScreenView.inputAmountView
        selectCategoryViewController.categories = categories
        selectCategoryViewController.selectCategoryView = addExpenseScreenView.selectCategoryView
        commentTextFieldController.textField = addExpenseScreenView.commentTextField
        commentTextFieldController.returnKeyType = .done
        commentTextFieldController.addDidTapReturnKeyObserver(self)
        commentTextFieldController.placeholder = localizer.localizeText("commentPlaceholder")
        addExpenseScreenView.addButton.setTitle("✓", for: .normal)
        addExpenseScreenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
    }
    
    func textFieldControllerDidTapReturnKey(_ textFieldController: AUITextFieldController) {
        view.endEditing(true)
    }
    
    // MARK: Events
    
    @objc func addButtonTouchUpInsideEventAction() {
        let amount = inputAmountViewController.input
        guard let category = selectCategoryViewController.selectedCategory else { return }
    }
    
}
