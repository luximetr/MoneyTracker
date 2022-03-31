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
    var backClosure: (() -> Void)?
    var editCategoryClosure: ((Category) throws -> Void)?
    
    // MARK: Initializer
    
    init(category: Category) {
        self.category = category
        super.init()
    }
    
    // MARK: View
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    override func loadView() {
        view = ScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.editButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setContent()
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "EditCategoryScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenView.nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func editButtonTouchUpInsideEventAction() {
        do {
            guard let name = screenView.nameTextField.text, !name.isEmpty else { return }
            let addingCategory = Category(id: category.id, name: name)
            try editCategoryClosure?(addingCategory)
        } catch {}
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        screenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        screenView.setKeyboardFrame(nil)
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.nameTextField.text = category.name
        screenView.editButton.setTitle(localizer.localizeText("save"), for: .normal)
    }
    
}


