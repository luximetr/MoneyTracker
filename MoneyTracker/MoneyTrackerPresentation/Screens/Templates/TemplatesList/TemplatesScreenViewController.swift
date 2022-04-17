//
//  TemplatesScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

final class TemplatesScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private var templates: [ExpenseTemplate]
    
    // MARK: - Life cycle
    
    init(appearance: Appearance, language: Language, templates: [ExpenseTemplate]) {
        self.templates = templates
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var addTemplateClosure: (() -> Void)?
    var didSelectTemplateClosure: ((ExpenseTemplate) -> Void)?
    var didDeleteTemplateClosure: ((ExpenseTemplate) -> Void)?
    var didReorderTemplatesClosure: (([ExpenseTemplate]) -> Void)?
    
    // MARK: - Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        return ScreenLocalizer(language: language, stringsTableName: "TemplatesScreenStrings")
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
    private func setContent() {
        templatesScreenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: - View
    
    private var templatesScreenView: TemplatesScreenView {
        return view as! TemplatesScreenView
    }
    
    override func loadView() {
        view = TemplatesScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        templatesScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    // MARK: - TableView
    
    private let tableViewController = AUIClosuresTableViewController()
    private let sectionController = AUIEmptyTableViewSectionController()
    
    private func setupTableViewController() {
        tableViewController.tableView = templatesScreenView.tableView
        tableViewController.targetIndexPathForMoveFromRowAtClosure = { sourceCellController, destinationCellController in
            if destinationCellController is TemplatesScreenAddTemplateTableViewCellController {
                return sourceCellController
            } else {
                return destinationCellController
            }
        }
        tableViewController.moveCellControllerClosure = { [weak self] sourceCellController, destinationCellController in
            guard let self = self else { return }
            guard let templateId1 = (sourceCellController as? TemplateTableViewCellController)?.templateId else { return }
            guard let templateId2 = (destinationCellController as? TemplateTableViewCellController)?.templateId else { return }
            guard let i = self.templates.firstIndex(where: { $0.id == templateId1 }) else { return }
            guard let j = self.templates.firstIndex(where: { $0.id == templateId2 }) else { return }
            self.templates.swapAt(i, j)
            self.didReorderTemplatesClosure?(self.templates)
        }
        tableViewController.dragInteractionEnabled = true
        var cellControllers: [AUITableViewCellController] = []
        
        let templatesCellControllers = createTemplatesCellControllers(templates: templates)
        cellControllers.append(contentsOf: templatesCellControllers)
        let addTemplateCellController = createAddTemplateCellController()
        cellControllers.append(addTemplateCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    // MARK: - Template
    
    private func createTemplatesCellControllers(templates: [ExpenseTemplate]) -> [TemplateTableViewCellController] {
        return templates.map { createTemplateCellController(template: $0) }
    }
    
    private func createTemplateCellController(template: ExpenseTemplate) -> TemplateTableViewCellController {
        let cellController = TemplateTableViewCellController(
            templateId: template.id,
            name: template.name,
            amount: template.amount,
            balanceAccountName: template.balanceAccount.name,
            currencyCode: template.balanceAccount.currency.rawValue,
            categoryName: template.category.name,
            comment: template.comment
        )
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.templatesScreenView.templateTableViewCell(indexPath)
            cell.balanceAccountPrefixLabel.text = self.localizer.localizeText("balanceAccountPrefix")
            cell.categoryPrefixLabel.text = self.localizer.localizeText("categoryPrefix")
            return cell
        }
        cellController.canMoveCellClosure = {
            return true
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let deleteAction = UIContextualAction(style: .destructive, title:  self.localizer.localizeText("delete"), handler: { contextualAction, view, success in
                self.didDeleteTemplateClosure?(template)
                self.tableViewController.deleteCellControllerAnimated(cellController, .left) { finished in
                    success(true)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.estimatedHeightClosure = { [weak self] in
            return self?.templatesScreenView.templateTableViewCellEstimatedHeight() ?? 0
        }
        cellController.heightClosure = { [weak self] in
            return self?.templatesScreenView.templateTableViewCellHeight() ?? 0
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            guard let selectedTemplate = self.templates.first(where: { $0.id == template.id }) else { return }
            self.didSelectTemplate(selectedTemplate)
        }
        return cellController
    }
    
    private func didSelectTemplate(_ template: ExpenseTemplate) {
        didSelectTemplateClosure?(template)
    }
    
    func showTemplateAdded(_ template: ExpenseTemplate) {
        let cellController = createTemplateCellController(template: template)
        templates.append(template)
        if let lastTemplateCellController = sectionController.cellControllers.reversed().first(where: { $0 is TemplateTableViewCellController }) {
            tableViewController.insertCellControllers([cellController], afterCellController: lastTemplateCellController, inSection: sectionController)
        } else {
            tableViewController.insertCellControllerAtSectionBeginning(sectionController, cellController: cellController)
        }
    }
    
    func showTemplateUpdated(_ updatedTemplate: ExpenseTemplate) {
        let templatesCellControllers = sectionController.cellControllers.compactMap { $0 as? TemplateTableViewCellController }
        let updatingTemplateCellController = templatesCellControllers.first(where: { $0.templateId == updatedTemplate.id })
        updatingTemplateCellController?.name = updatedTemplate.name
        updatingTemplateCellController?.amount = updatedTemplate.amount
        updatingTemplateCellController?.balanceAccountName = updatedTemplate.balanceAccount.name
        updatingTemplateCellController?.currencyCode = updatedTemplate.balanceAccount.currency.rawValue
        updatingTemplateCellController?.categoryName = updatedTemplate.category.name
        updatingTemplateCellController?.comment = updatedTemplate.comment
        guard let updatingTemplateIndex = templates.firstIndex(where: { $0.id == updatedTemplate.id }) else { return }
        templates[updatingTemplateIndex] = updatedTemplate
    }
    
    // MARK: - Add template
    
    private func createAddTemplateCellController() -> TemplatesScreenAddTemplateTableViewCellController {
        let cellController = TemplatesScreenAddTemplateTableViewCellController()
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.templatesScreenView.addTemplateTableViewCell(indexPath)
            cell._textLabel.text = self.localizer.localizeText("addTemplate")
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            return self?.templatesScreenView.addTemplateTableViewCellEstimatedHeight() ?? 0
        }
        cellController.heightClosure = { [weak self] in
            return self?.templatesScreenView.addTemplateTableViewCellHeight() ?? 0
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didTapOnAddTemplate()
        }
        return cellController
    }
    
    private func didTapOnAddTemplate() {
        addTemplateClosure?()
    }
    
    // MARK: - Back button
    
    @objc
    private func didTapOnBackButton() {
        backClosure?()
    }
}
