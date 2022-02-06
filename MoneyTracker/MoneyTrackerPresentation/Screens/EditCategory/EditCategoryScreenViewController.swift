//
//  EditCategoryScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

final class EditCategoryScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private let category: Category
    
    // MARK: Initializer
    
    init(category: Category) {
        self.category = category
        super.init()
    }
    
    // MARK: Delegation
    
    var editCategoryClosure: ((Category) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = EditCategoryScreenView()
    }
    
    private var editCategoryScreenView: EditCategoryScreenView! {
        return view as? EditCategoryScreenView
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "EditCategoryScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editCategoryScreenView.titleLabel.text = localizer.localizeText("title")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        editCategoryScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        editCategoryScreenView.addButton.setTitle(localizer.localizeText("save"), for: .normal)
        editCategoryScreenView.nameTextField.text = category.name
        editCategoryScreenView.nameTextField.becomeFirstResponder()
    }
    
    // MARK: Events
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        editCategoryScreenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        editCategoryScreenView.setKeyboardFrame(nil)
    }
    
    @objc private func add() {
        let name = editCategoryScreenView.nameTextField.text ?? "????"
        let addingCategory = Category(id: category.id, name: name)
        editCategoryClosure?(addingCategory)
    }
    
}


