//
//  MonthPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthPickerViewController: AUIEmptyViewController {
    
    // MARK: Data
    
    private(set) var selectedMonth: Date?
    private var months: [Date] = []
    
    func setSelectedMonth(_ selectedMonth: Date?) {
        self.selectedMonth = selectedMonth
        selectedCellController?.setSelected(false)
        if let selectedMonth = selectedMonth {
            cellControllerForMonth(selectedMonth)?.setSelected(true)
        }
    }
    
    func setMonths(_ months: [Date]) {
        self.months = months
        setCollectionViewControllerContent()
    }
    
    // MARK: MonthPickerView
    
    var monthPickerView: MonthPickerView? {
        set { view = newValue }
        get { return view as? MonthPickerView }
    }
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private var monthCellControllers: [MonthCollectionViewCellController]? {
        return sectionController.cellControllers as? [MonthCollectionViewCellController]
    }
    private var selectedCellController: MonthCollectionViewCellController? {
        return monthCellControllers?.first(where: { $0.isSelected })
    }
    private func cellControllerForMonth(_ month: Date) -> MonthCollectionViewCellController? {
        guard let cellController = sectionController.cellControllers.first(where: { cellController in
            guard let monthCollectionViewCellController = cellController as? MonthCollectionViewCellController else { return false }
            return monthCollectionViewCellController.month == month
        }) as? MonthCollectionViewCellController else { return nil }
        return cellController
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
        let cellController = MonthCollectionViewCellController(month: month, isSelected: month == selectedMonth)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            let monthCollectionViewCell = self.monthPickerView!.monthCollectionViewCell(indexPath)
            return monthCollectionViewCell
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            let size = self.monthPickerView!.monthCollectionViewCellSize(MonthCollectionViewCellController.month(month))
            return size
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectMonthCellController(cellController)
        }
        return cellController
    }
    
    private func didSelectMonthCellController(_ cellController: MonthCollectionViewCellController) {
        guard selectedCellController !== cellController else { return }
        selectedCellController?.setSelected(false)
        if let indexPath = collectionViewController.indexPathForCellController(cellController) {
            monthPickerView?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            cellController.setSelected(true)
        }
        didSelectMonthClosure?(cellController.month)
    }
    var didSelectMonthClosure: ((Date) -> ())?
    
    // MARK: States
    
    func selectMonth(_ month: Date, animated: Bool) {
        guard let cellController = cellControllerForMonth(month) else { return }
        guard selectedCellController !== cellController else { return }
        selectedCellController?.setSelected(false)
        if let indexPath = collectionViewController.indexPathForCellController(cellController) {
            self.selectedMonth = month
            monthPickerView?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            cellController.setSelected(true)
        }
    }
    
}
}
