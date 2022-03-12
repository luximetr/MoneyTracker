//
//  DashboardScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit

class DashboardScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "DashboardScreenStrings")
        return localizer
    }()
    
    // MARK: - Life cycle
    
    init(templates: [ExpenseTemplate]) {
        self.templates = templates
    }
    
    // MARK: - View
    
    private var dashboardScreenView: DashboardScreenView {
        return view as! DashboardScreenView
    }
    
    // MARK: - View - Life cycle
    
    override func loadView() {
        view = DashboardScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showTemplates(templates)
        dashboardScreenView.titleLabel.text = localizer.localizeText("title")
        dashboardScreenView.templatesHeaderLabel.text = localizer.localizeText("fastRecordTitle")
    }
    
    // MARK: - View - Setup
    
    private func setupView() {
        setupTemplatesCollectionController()
    }
    
    // MARK: - Templates - Public
    
    private let templates: [ExpenseTemplate]
    
    func showTemplates(_ templates: [ExpenseTemplate]) {
        showTemplatesCells(templates: templates)
    }
    
    func removeTemplate(templateId: ExpenseTemplateId) {
        
    }
    
    func addTemplate(template: ExpenseTemplate) {
        
    }
    
    func reorderTemplates(orderedIds: [ExpenseTemplateId]) {
        
    }
    
    // MARK: - Templates - Collection controller
    
    private let templatesCollectionController = AUIEmptyCollectionViewController()
    
    private func setupTemplatesCollectionController() {
        templatesCollectionController.collectionView = dashboardScreenView.templatesCollectionView
    }
    
    // MARK: - Templates - Cell controllers
    
    private func showTemplatesCells(templates: [ExpenseTemplate]) {
        let cellControllers = createTemplatesCells(templates: templates)
        let sectionController = AUIEmptyCollectionViewSectionController()
        sectionController.cellControllers = cellControllers
        templatesCollectionController.sectionControllers = [sectionController]
    }
    
    private func createTemplatesCells(templates: [ExpenseTemplate]) -> [AUICollectionViewCellController] {
        return templates.map { createTemplateCell(template: $0) }
    }
    
    private func createTemplateCell(template: ExpenseTemplate) -> AUICollectionViewCellController {
        let cellController = AUIClosuresCollectionViewCellController()
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.dashboardScreenView.createTemplateCell(indexPath: indexPath, template: template)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.dashboardScreenView.getTemplateCellSize()
        }
        return cellController
    }
}
