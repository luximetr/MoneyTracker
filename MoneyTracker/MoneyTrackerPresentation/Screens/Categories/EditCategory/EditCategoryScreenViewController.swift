//
//  EditCategoryScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

final class EditCategoryScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private let categoryColors: [CategoryColor]
    private let category: Category
    private var categoryIconName: String
    var backClosure: (() -> Void)?
    var editCategoryClosure: ((EditingCategory) throws -> Void)?
    var selectIconClosure: ((CategoryColor) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, category: Category, categoryColors: [CategoryColor]) {
        self.category = category
        self.categoryColors = categoryColors
        self.categoryIconName = category.iconName
        self.colorPickerController = CategoryColorHorizontalPickerController(appearance: appearance)
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
        screenView.selectIconButton.addTarget(self, action: #selector(selectIconButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.editButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupColorPickerController()
        setContent()
        updateView(categoryColor: category.color)
        showCategoryIcon(iconName: categoryIconName)
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "EditCategoryScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.nameTextField.text = category.name
        screenView.colorPickerTitleLabel.text = localizer.localizeText("colorPickerTitle")
        screenView.editButton.setTitle(localizer.localizeText("save"), for: .normal)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        colorPickerController.changeAppearance(appearance)
        updateView(categoryColor: category.color)
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
            let name = screenView.nameTextField.text
            let selectedColor = colorPickerController.selectedColor
            let editingCategory = EditingCategory(id: category.id, name: name, color: selectedColor, iconName: categoryIconName)
            try editCategoryClosure?(editingCategory)
        } catch {}
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
    
    // MARK: Color picker
    
    private let colorPickerController: CategoryColorHorizontalPickerController
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = screenView.colorPickerView
        colorPickerController.didSelectColorClosure = { [weak self] color in
            self?.updateView(categoryColor: color)
        }
        colorPickerController.setColors(categoryColors, selectedColor: category.color)
    }
    
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    private func updateView(categoryColor: CategoryColor) {
        let uiColor = uiColorProvider.getUIColor(categoryColor: categoryColor, appearance: appearance)
        screenView.iconView.backgroundColor = uiColor
        screenView.nameTextField.textColor = uiColor
        screenView.editButton.backgroundColor = uiColor
    }
    
    // MARK: Icon
    
    func showCategoryIcon(iconName: String) {
        categoryIconName = iconName
        screenView.iconView.setIcon(named: iconName)
    }
    
}


