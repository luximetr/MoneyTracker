//
//  TemplatesViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 01.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class TemplatesViewController: EmptyViewController {
    
    // MARK: Data

    var appearance: Appearance
    var templates: [ExpenseTemplate] = []
    
    // MARK: Initializer
    
    init(locale: MyLocale, appearance: Appearance, templates: [ExpenseTemplate]) {
        self.appearance = appearance
        self.templates = templates
        super.init(locale: locale)
    }
    
    // MARK: CategoryPickerView
  
    var templatesView: TemplatesView? {
        set { view = newValue }
        get { return view as? TemplatesView }
    }
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private var templatesCellControllers: [TemplateCollectionViewCellController]? {
        let templatesCellControllers = sectionController.cellControllers as? [TemplateCollectionViewCellController]
        return templatesCellControllers
    }
    private func templateCellController(_ template: ExpenseTemplate) -> TemplateCollectionViewCellController? {
        let templateCellController = templatesCellControllers?.first(where: { $0.template == template })
        return templateCellController
    }
  
    override func setupView() {
        super.setupView()
        setupTemplatesView()
    }
    
    func setupTemplatesView() {
        templatesView?.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        collectionController.collectionView = templatesView?.collectionView
        setContent()
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupTemplatesView()
    }
  
    func unsetupTemplatesView() {
        collectionController.collectionView = nil
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "DashboardTemplatesViewStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: MyLocale) {
        super.changeLocale(locale)
        localizer.changeLanguage(locale.language)
        setContent()
    }
    
    private func setContent() {
        templatesView?.titleLabel.text = localizer.localizeText("title")
        templatesView?.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        templatesView?.layoutSubviews()
        setCollectionControllerContent()
    }
    
    private func setCollectionControllerContent() {
        var cellControllers: [AUICollectionViewCellController] = []
        for template in templates {
            let cellController = createTemplateCellController(template: template)
            cellControllers.append(cellController)
        }
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    private func createTemplateCellController(template: ExpenseTemplate) -> AUICollectionViewCellController {
        let cellController = TemplateCollectionViewCellController(template: template)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.templatesView!.templateCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.templatesView!.templateCollectionViewCellSize()
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            self.didSelectTemplateCellController(cellController)
        }
        return cellController
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        templatesView?.changeAppearance(appearance)
    }
    
    // MARK: Events
    
    func addTemplate(_ template: ExpenseTemplate) {
        templates.append(template)
        setContent()
    }
    
    func editTemplate(_ template: ExpenseTemplate) {
        guard let firstIndex = templates.firstIndex(where: { $0.id == template.id }) else { return }
        templates[firstIndex] = template
        setContent()
    }
    
    func deleteTemplate(_ template: ExpenseTemplate) {
        guard let firstIndex = templates.firstIndex(where: { $0.id == template.id }) else { return }
        templates.remove(at: firstIndex)
        if let templateCellController = self.templateCellController(template) {
            collectionController.deleteCellController(templateCellController, completion: nil)
        }
    }
    
    func orderTemplates(_ templates: [ExpenseTemplate]) {
        self.templates = templates
        setContent()
    }
    
    var addTemplateClosure: (() -> Void)?
    @objc private func addButtonTouchUpInsideEventAction() {
        addTemplateClosure?()
    }
    
    var selectTemplateClosure: ((ExpenseTemplate) -> Void)?
    private func didSelectTemplateCellController(_ templateCellController: TemplateCollectionViewCellController) {
        let template = templateCellController.template
        selectTemplateClosure?(template)
    }
    
}
}
