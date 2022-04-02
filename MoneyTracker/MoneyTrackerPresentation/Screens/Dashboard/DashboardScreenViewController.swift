//
//  DashboardScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit

final class DashboardScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private var templates: [ExpenseTemplate]
    var didTapOnAddExpenseClosure: (() -> Void)?
    var addExpenseClosure: ((AddingExpense) throws -> Expense)?
    var displayExpenseAddedSnackbarClosure: ((Expense) -> Void)?
    var addTemplateClosure: (() -> Void)?
    var addCategoryClosure: (() -> Void)?
    
    // MARK: Initializer
    
    init(categories: [Category], templates: [ExpenseTemplate]) {
        self.templates = templates
        self.categoryPickerViewController = CategoryPickerViewController(categories: categories)
        super.init()
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView()
    }
    
    private let categoryPickerViewController: CategoryPickerViewController
    private let templatesCollectionController = AUIEmptyCollectionViewController()
    private let templatesSectionController = AUIEmptyCollectionViewSectionController()
    private func findTemplateCellController(templateId: ExpenseTemplateId) -> TemplateCollectionCellController? {
        return templatesSectionController.cellControllers.first(where: {
            ($0 as? TemplateCollectionCellController)?.templateId == templateId
        }) as? TemplateCollectionCellController
    }
    private let templatesPanGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTemplates(templates)
        categoryPickerViewController.categoryPickerView = screenView.categoryPickerView
        categoryPickerViewController.addCategoryClosure = { [weak self] in
            guard let self = self else { return }
            self.addCategoryClosure?()
        }
        categoryPickerViewController.selectCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            self.didTapOnAddExpense()
            
        }
        templatesCollectionController.collectionView = screenView.templatesCollectionView
        screenView.templatesView.addGestureRecognizer(templatesPanGestureRecognizer)
        templatesPanGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerAction))
        screenView.templatesView.addButton.addTarget(self, action: #selector(addTemplateButtonTouchUpInsideEventAcion), for: .touchUpInside)
        setContent()
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "DashboardScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        screenView.templatesView.titleLabel.text = localizer.localizeText("templatesTitle")
        screenView.templatesView.addButton.setTitle(localizer.localizeText("addTemplate"), for: .normal)
    }
    
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
        let cellController = TemplateCollectionCellController(title: template.name, templateId: template.id)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.screenView.createTemplateCell(indexPath: indexPath, template: template)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.screenView.getTemplateCellSize()
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            guard let template = self.templates.first(where: { $0.id == template.id }) else { return }
            self.didSelectTemplate(template)
        }
        return cellController
    }
    
    // MARK: Events
    
    @objc private func addTemplateButtonTouchUpInsideEventAcion() {
        addTemplateClosure?()
    }
    
    @objc private func didTapOnAddExpense() {
        didTapOnAddExpenseClosure?()
    }
    
    private func didSelectTemplate(_ template: ExpenseTemplate) {
        guard let addExpenseClosure = addExpenseClosure else { return }
        do {
            let amount = template.amount
            let date = Date()
            let component = template.comment
            let account = template.balanceAccount
            let category = template.category
            let addingExpense = AddingExpense(amount: amount, date: date, comment: component, account: account, category: category)
            let addedExpense = try addExpenseClosure(addingExpense)
            displayExpenseAddedSnackbarClosure?(addedExpense)
        } catch {
            
        }
    }
    
    private var previousPanGestureRecognizerTranslation: CGPoint?
    @objc private func panGestureRecognizerAction() {
        let state = templatesPanGestureRecognizer.state
        switch state {
        case .began:
            previousPanGestureRecognizerTranslation = templatesPanGestureRecognizer.translation(in: screenView)
        case .possible:
            break
        case .changed:
            if let previousPanGestureRecognizerTranslation = previousPanGestureRecognizerTranslation {
                let translation = templatesPanGestureRecognizer.translation(in: screenView)
                let j = translation.y - previousPanGestureRecognizerTranslation.y
                screenView.moveAccountViewIfPossible(j)
                self.previousPanGestureRecognizerTranslation = translation
            }
        case .ended:
            screenView.finishMove()
        case .cancelled:
            screenView.finishMove()
        case .failed:
            screenView.finishMove()
        @unknown default:
            screenView.finishMove()
        }
    }
    
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
        templates.append(template)
        let cellController = createTemplateCellController(template: template)
        templatesCollectionController.appendCellController(cellController, toSectionController: templatesSectionController, completion: nil)
    }
    
    func addCategory(_ category: Category) {
        categoryPickerViewController.addCategory(category)
    }

}
