//
//  AddCategoryScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import UIKit
import AUIKit

final class AddCategoryScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private let categoryColors: [UIColor]
    private var categoryIconName: String
    var backClosure: (() -> Void)?
    var addCategoryClosure: ((AddingCategory) throws -> Void)?
    var selectIconClosure: ((UIColor) -> Void)?
    
    // MARK: Init
    
    init(appearance: Appearance, language: Language, categoryColors: [UIColor], categoryIconName: String) {
        self.categoryColors = categoryColors
        self.categoryIconName = categoryIconName
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: View
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.addButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.selectIconButton.addTarget(self, action: #selector(selectIconButtonTouchUpInsideEventAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        showCategoryIcon(iconName: categoryIconName)
        setupColorPickerController()
        setContent()
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "AddCategoryScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
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
            guard let selectedColor = colorPickerController.selectedColor else { return }
            let addingCategory = AddingCategory(name: name, color: selectedColor, iconName: categoryIconName)
            try addCategoryClosure?(addingCategory)
        } catch { }
    }
    
    @objc private func selectIconButtonTouchUpInsideEventAction() {
        guard let selectedColor = colorPickerController.selectedColor else { return }
        selectIconClosure?(selectedColor)
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
    
    // MARK: - Color
    
    private let colorPickerController = ColorHorizontalPickerController()
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = screenView.colorPickerView
        colorPickerController.didSelectColorClosure = { [weak self] color in
            self?.updateView(categoryColor: color)
        }
        guard let selectedColor = categoryColors.first else { return }
        colorPickerController.setColors(categoryColors, selectedColor: selectedColor)
        updateView(categoryColor: selectedColor)
    }
    
    private func updateView(categoryColor: UIColor) {
        screenView.iconView.backgroundColor = categoryColor
        screenView.nameTextField.textColor = categoryColor
        screenView.addButton.backgroundColor = categoryColor
    }
    
    // MARK: Icon
    
    func showCategoryIcon(iconName: String) {
        categoryIconName = iconName
        screenView.iconView.setIcon(named: iconName)
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.colorPickerTitleLabel.text = localizer.localizeText("colorPickerTitle")
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
    }
    
}

