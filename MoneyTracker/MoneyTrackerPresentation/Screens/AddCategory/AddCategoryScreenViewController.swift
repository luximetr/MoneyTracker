//
//  AddCategoryScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import UIKit
import AUIKit

final class AddCategoryScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Delegation
    
    var addCategoryClosure: ((AddingCategory) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = AddCategoryScreenView()
    }
    
    private var addCategoryScreenView: AddCategoryScreenView! {
        return view as? AddCategoryScreenView
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddCategoryScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addCategoryScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        addCategoryScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addCategoryScreenView.nameTextField.becomeFirstResponder()
    }
    
    // MARK: Events
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        addCategoryScreenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        addCategoryScreenView.setKeyboardFrame(nil)
    }
    
    @objc private func add() {
        let name = addCategoryScreenView.nameTextField.text ?? "????"
        let addingCategory = AddingCategory(name: name)
        addCategoryClosure?(addingCategory)
    }
    
}

