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
    
    private let categoryColors: [CategoryColor]
    private var categoryIconName: String
    var backClosure: (() -> Void)?
    var addCategoryClosure: ((AddingCategory) throws -> Void)?
    var selectIconClosure: ((CategoryColor) -> Void)?
    
    // MARK: Init
    
    init(appearance: Appearance, language: Language, categoryColors: [CategoryColor], categoryIconName: String) {
        self.categoryColors = categoryColors
        self.categoryIconName = categoryIconName
        self.colorPickerController = CategoryColorHorizontalPickerController(appearance: appearance)
        self.errorSnackbarViewController = ErrorSnackbarViewController(appearance: appearance)
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
        showCategoryIcon(iconName: categoryIconName)
        setupViewTapRecognizer()
        setupColorPickerController()
        setupErrorSnackbarViewController()
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
            guard let name = screenView.nameTextField.text, !name.isEmpty else {
                showErrorSnackbar(localizer.localizeText("emptyNameErrorMessage"))
                return
            }
            guard let selectedColor = colorPickerController.selectedColor else {
                showErrorSnackbar(localizer.localizeText("emptyColorErrorMessage"))
                return
            }
            let addingCategory = AddingCategory(name: name, color: selectedColor, iconName: categoryIconName)
            try addCategoryClosure?(addingCategory)
        } catch { }
    }
    
    @objc private func selectIconButtonTouchUpInsideEventAction() {
        guard let selectedColor = colorPickerController.selectedColor else { return }
        selectIconClosure?(selectedColor)
    }
    
    // MARK: - View - Tap Recognizer
    
    private func setupViewTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func didTapOnView() {
        view.endEditing(true)
    }
    
    // MARK: - Color
    
    private let colorPickerController: CategoryColorHorizontalPickerController
    
    private func setupColorPickerController() {
        colorPickerController.pickerView = screenView.colorPickerView
        colorPickerController.didSelectColorClosure = { [weak self] color in
            self?.updateView(categoryColor: color)
        }
        guard let selectedColor = categoryColors.first else { return }
        colorPickerController.setColors(categoryColors, selectedColor: selectedColor)
        updateView(categoryColor: selectedColor)
    }
    
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    private func updateView(categoryColor: CategoryColor) {
        let uiColor = uiColorProvider.getUIColor(categoryColor: categoryColor, appearance: appearance)
        screenView.iconView.backgroundColor = uiColor
        screenView.nameTextField.textColor = uiColor
        screenView.addButton.backgroundColor = uiColor
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
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        colorPickerController.changeAppearance(appearance)
        if let selectedColor = colorPickerController.selectedColor {
            updateView(categoryColor: selectedColor)
        }
    }
    
    // MARK: - Error Snackbar
    
    private let errorSnackbarViewController: ErrorSnackbarViewController
    
    private func setupErrorSnackbarViewController() {
        errorSnackbarViewController.errorSnackbarView = screenView.errorSnackbarView
    }
    
    private func showErrorSnackbar(_ message: String) {
        errorSnackbarViewController.showMessage(message)
    }
    
}

