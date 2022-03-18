//
//  TemplatesScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

final class TemplatesScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    private var templates: [ExpenseTemplate]
    
    // MARK: - Life cycle
    
    init(templates: [ExpenseTemplate]) {
        self.templates = templates
    }
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var addTemplateClosure: (() -> Void)?
    var didSelectTemplateClosure: (() -> Void)?
    var deleteTemplateClosure: (() -> Void)?
    var orderTemplateClosure: (([ExpenseTemplate]) -> Void)?
    
    // MARK: - Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        return ScreenLocalizer(language: .english, stringsTableName: "TemplatesScreenStrings")
    }()
    
    // MARK: - View
    
    private var templatesScreenView: TemplatesScreenView {
        return view as! TemplatesScreenView
    }
    
    override func loadView() {
        view = TemplatesScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        templatesScreenView.titleLabel.text = localizer.localizeText("title")
        templatesScreenView.backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
        setupTableViewController()
    }
    
    // MARK: - TableView
    
    private let tableViewController = AUIClosuresTableViewController()
    
    private func setupTableViewController() {
        tableViewController.tableView = templatesScreenView.tableView
        let sectionController = AUIEmptyTableViewSectionController()
        var cellControllers: [AUITableViewCellController] = []
        
        let templatesCellControllers = createTemplatesCellControllers(templates: templates)
        cellControllers.append(contentsOf: templatesCellControllers)
        let addTemplateCellController = createAddTemplateCellController()
        cellControllers.append(addTemplateCellController)
        
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    // MARK: - Template
    
    private func createTemplatesCellControllers(templates: [ExpenseTemplate]) -> [TemplatesScreenTemplateTableViewCellController] {
        return templates.map { createTemplateCellController(template: $0) }
    }
    
    private func createTemplateCellController(template: ExpenseTemplate) -> TemplatesScreenTemplateTableViewCellController {
        let cellController = TemplatesScreenTemplateTableViewCellController()
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.templatesScreenView.templateTableViewCell(indexPath)
            cell.nameLabel.text = template.name
            cell.amountLabel.text = "\(template.amount) SGD"
            cell.balanceAccountPrefixLabel.text = "from"
            cell.balanceAccountLabel.text = template.balanceAccount.name
            cell.categoryPrefixLabel.text = "to"
            cell.categoryLabel.text = template.category.name
            cell.commentLabel.text = template.comment
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            return self?.templatesScreenView.templateTableViewCellEstimatedHeight() ?? 0
        }
        cellController.heightClosure = { [weak self] in
            return self?.templatesScreenView.templateTableViewCellHeight() ?? 0
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectTemplate(template)
        }
        return cellController
    }
    
    private func didSelectTemplate(_ template: ExpenseTemplate) {
        
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
