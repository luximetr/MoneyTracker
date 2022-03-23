//
//  DashboardScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit

class DashboardScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Delegation
    
    var didTapOnAddExpenseClosure: (() -> Void)?
    var didSelectTemplateClosure: ((ExpenseTemplate) -> Void)?
    
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
        dashboardScreenView.addExpenseButton.setTitle(localizer.localizeText("addExpenseButtonTitle"), for: .normal)
        dashboardScreenView.addExpenseButton.addTarget(self, action: #selector(didTapOnAddExpense), for: .touchUpInside)
    }
    
    // MARK: - View - Setup
    
    private func setupView() {
        setupTemplatesCollectionController()
    }
    
    // MARK: - Expense - Add
    
    @objc
    private func didTapOnAddExpense() {
        didTapOnAddExpenseClosure?()
    }
    
    // MARK: - Templates - Public
    
    private var templates: [ExpenseTemplate]
    private let maxVisibleTemplates = 6
    
    func showTemplates(_ templates: [ExpenseTemplate]) {
        self.templates = templates
        showTemplatesCells(templates: templates)
    }
    
    func showTemplateUpdated(_ updatedTemplate: ExpenseTemplate) {
        guard let cellController = findTemplateCellController(templateId: updatedTemplate.id) else { return }
        cellController.title = updatedTemplate.name
        guard let templateIndex = templates.firstIndex(where: { $0.id == updatedTemplate.id }) else { return }
        templates[templateIndex] = updatedTemplate
    }
    
    func showTemplateRemoved(templateId: ExpenseTemplateId) {
        guard let cellController = findTemplateCellController(templateId: templateId) else { return }
        templatesCollectionController.deleteCellController(cellController, completion: nil)
        guard let templateIndex = templates.firstIndex(where: { $0.id == templateId }) else { return }
        templates.remove(at: templateIndex)
    }
    
    func showTemplatesReordered(_ reorderedTemplates: [ExpenseTemplate]) {
        templates = reorderedTemplates
        showTemplatesCells(templates: reorderedTemplates)
    }
    
    func addTemplate(template: ExpenseTemplate) {
        guard templates.count < maxVisibleTemplates else { return }
        templates.append(template)
        let cellController = createTemplateCellController(template: template)
        templatesCollectionController.appendCellController(cellController, toSectionController: templatesSectionController, completion: nil)
    }
    
    // MARK: - Templates - Collection controller
    
    private let templatesCollectionController = AUIEmptyCollectionViewController()
    
    private func setupTemplatesCollectionController() {
        templatesCollectionController.collectionView = dashboardScreenView.templatesCollectionView
    }
    
    // MARK: - Templates - Cell controllers
    
    private let templatesSectionController = AUIEmptyCollectionViewSectionController()
    
    private func showTemplatesCells(templates: [ExpenseTemplate]) {
        let cellControllers = createTemplatesCellControllers(templates: templates)
        templatesSectionController.cellControllers = cellControllers
        templatesCollectionController.sectionControllers = [templatesSectionController]
        templatesCollectionController.reload()
    }
    
    private func createTemplatesCellControllers(templates: [ExpenseTemplate]) -> [AUICollectionViewCellController] {
        return templates.map { createTemplateCellController(template: $0) }
    }
    
    private func createTemplateCellController(template: ExpenseTemplate) -> AUICollectionViewCellController {
        let cellController = DashboardTemplateCollectionCellController(title: template.name, templateId: template.id)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.dashboardScreenView.createTemplateCell(indexPath: indexPath, template: template)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.dashboardScreenView.getTemplateCellSize()
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            guard let template = self.templates.first(where: { $0.id == template.id }) else { return }
            self.didSelectTemplate(template)
        }
        return cellController
    }
    
    private func didSelectTemplate(_ template: ExpenseTemplate) {
        didSelectTemplateClosure?(template)
    }
    
    private func findTemplateCellController(templateId: ExpenseTemplateId) -> DashboardTemplateCollectionCellController? {
        return templatesSectionController.cellControllers.first(where: {
            ($0 as? DashboardTemplateCollectionCellController)?.templateId == templateId
        }) as? DashboardTemplateCollectionCellController
    }
}
