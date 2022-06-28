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
    
    init(appearance: Appearance, locale: Locale, category: Category, categoryColors: [CategoryColor]) {
        self.category = category
        self.categoryColors = categoryColors
        self.categoryIconName = category.iconName
        self.colorPickerController = CategoryColorHorizontalPickerController(appearance: appearance)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
        super.init(appearance: appearance, locale: locale)
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
        setupViewTapRecognizer()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.selectIconButton.addTarget(self, action: #selector(selectIconButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.editButton.addTarget(self, action: #selector(editButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupColorPickerController()
        updateView(categoryColor: category.color)
        showCategoryIcon(iconName: categoryIconName)
        setupErrorSnackbarViewController()
        setContent()
    }
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "EditCategoryScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
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
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
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
            let name = screenView.nameTextField.text ?? ""
            guard !name.isEmpty else {
                showErrorSnackbar(message: localizer.localizeText("emptyNameErrorMessage"))
                return
            }
            guard let selectedColor = colorPickerController.selectedColor else {
                showErrorSnackbar(message: localizer.localizeText("emptyColorErrorMessage"))
                return
            }
            let editingCategory = EditingCategory(id: category.id, name: name, color: selectedColor, iconName: categoryIconName)
            try editCategoryClosure?(editingCategory)
        } catch {}
    }
    
    @objc private func selectIconButtonTouchUpInsideEventAction() {
        guard let selectedColor = colorPickerController.selectedColor else { return }
        selectIconClosure?(selectedColor)
    }
    
    // MARK: - View - Tap recognizer
    
    private func setupViewTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func didTapOnView() {
        view.endEditing(true)
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
    
    // MARK: - Error snackbar
    
    private let errorSnackbarViewController: ErrorSnackbarViewController
    
    private func setupErrorSnackbarViewController() {
        errorSnackbarViewController.errorSnackbarView = screenView.errorSnackbarView
    }
    
    private func showErrorSnackbar(message: String) {
        errorSnackbarViewController.showMessage(message)
    }
    
}


