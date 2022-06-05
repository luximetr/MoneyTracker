//
//  MonthPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticExpensesByCategoriesScreenViewController {
final class MonthPickerViewController: EmptyViewController {
    
    // MARK: Data
    
    private var months: [Date] = []
    private(set) var selectedMonth: Date?
    
    func setMonths(_ months: [Date]) {
        self.months = months
        setCollectionViewControllerContent()
    }
    
    func setSelectedMonth(_ selectedMonth: Date?) {
        self.selectedMonth = selectedMonth
        if let selectedCellController = selectedMonthCellController {
            selectedCellController.setSelected(false)
        }
        if let selectedMonth = selectedMonth, let cellController = monthCellController(selectedMonth) {
            if let indexPath = collectionViewController.indexPathForCellController(cellController) {
                monthPickerView?.collectionViewScrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                cellController.setSelected(true)
            }
        }
    }
    
    // MARK: MonthPickerView
    
    var monthPickerView: MonthPickerView? {
        set { view = newValue }
        get { return view as? MonthPickerView }
    }
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private var monthsCellControllers: [MonthCollectionViewCellController]? {
        guard let monthCellControllers = sectionController.cellControllers as? [MonthCollectionViewCellController] else { return nil }
        return monthCellControllers
    }
    private var selectedMonthCellController: MonthCollectionViewCellController? {
        guard let selectedCellController = monthsCellControllers?.first(where: { $0.isSelected }) else { return nil }
        return selectedCellController
    }
    private func monthCellController(_ month: Date) -> MonthCollectionViewCellController? {
        guard let monthCellController = monthsCellControllers?.first(where: { $0.month == month }) else { return nil }
        return monthCellController
    }
  
    override func setupView() {
        super.setupView()
        setupMonthPickerView()
    }
  
    func setupMonthPickerView() {
        collectionViewController.collectionView = monthPickerView?.collectionView
        setCollectionViewControllerContent()
    }
  
    override func unsetupView() {
        super.unsetupView()
        unsetupMonthPickerView()
    }
  
    func unsetupMonthPickerView() {
        collectionViewController.collectionView = nil
        collectionViewController.sectionControllers = []
        collectionViewController.reload()
    }
    
    // MARK: Events
    
    var didSelectMonthClosure: ((Date) -> ())?
    private func didSelectMonthCellController(_ monthCellController: MonthCollectionViewCellController) {
        if let selectedMonthCellController = selectedMonthCellController {
            selectedMonthCellController.setSelected(false)
        }
        monthCellController.setSelected(true)
        if let indexPath = collectionViewController.indexPathForCellController(monthCellController) {
            monthPickerView?.collectionViewScrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        let month = monthCellController.month
        didSelectMonthClosure?(month)
    }
    
    // MARK: Content
    
    private lazy var monthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale.foundationLocale
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter
    }()
    
    private func setCollectionViewControllerContent() {
        collectionViewController.reload()
        var cellControllers: [AUICollectionViewCellController] = []
        for month in months {
            let accountCellController = createMonthCollectionViewCellController(month: month)
            cellControllers.append(accountCellController)
        }
        sectionController.cellControllers = cellControllers
        collectionViewController.sectionControllers = [sectionController]
        collectionViewController.reload()
    }
    
    private func createMonthCollectionViewCellController(month: Date) -> MonthCollectionViewCellController {
        let isSelected = month == selectedMonth
        let cellController = MonthCollectionViewCellController(locale: locale, month: month, isSelected: isSelected, monthDateFormatter: monthDateFormatter)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            let monthCollectionViewCell = self.monthPickerView!.monthCollectionViewCell(indexPath)
            return monthCollectionViewCell
        }
        cellController.sizeForCellClosure = { [weak self, weak cellController] in
            guard let self = self else { return .zero }
            guard let cellController = cellController else { return .zero }
            let size = self.monthPickerView!.monthCollectionViewCellSize(cellController.formatMonth(month))
            return size
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            self.didSelectMonthCellController(cellController)
        }
        return cellController
    }
    
}
}
