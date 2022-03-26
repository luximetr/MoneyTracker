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
    
    var months: [Date] = [] {
        didSet {
            setCollectionViewControllerContent()
        }
    }
    
    // MARK: MonthPickerView
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private func cellControllerForMonth(_ month: Date) -> MonthCollectionViewCellController? {
        guard let cellController = sectionController.cellControllers.first(where: { cellController in
            guard let monthCollectionViewCellController = cellController as? MonthCollectionViewCellController else { return false }
            return monthCollectionViewCellController.month == month
        }) as? MonthCollectionViewCellController else { return nil }
        return cellController
    }
  
    var monthPickerView: MonthPickerView? {
        set { view = newValue }
        get { return view as? MonthPickerView }
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
        let cellController = MonthCollectionViewCellController(month: month, isSelected: false)
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
    
    private var selectedCellController: MonthCollectionViewCellController?
    private func didSelectMonthCellController(_ cellController: MonthCollectionViewCellController) {
        guard selectedCellController !== cellController else { return }
        selectedCellController?.setSelected(false)
        selectedCellController = cellController
        if let indexPath = collectionViewController.indexPathForCellController(cellController) {
            monthPickerView?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            cellController.setSelected(true)
        }
        didSelectMonthClosure?(cellController.month)
    }
    var didSelectMonthClosure: ((Date) -> ())?
    
    // MARK: States
    
    var selectedMonth: Date? {
        guard let selectedCellController = selectedCellController else { return nil }
        let selectedMonth = selectedCellController.month
        return selectedMonth
    }
    
    func selectMonth(_ month: Date, animated: Bool) {
        guard let cellController = cellControllerForMonth(month) else { return }
        guard selectedCellController !== cellController else { return }
        selectedCellController?.setSelected(false)
        selectedCellController = cellController
        if let indexPath = collectionViewController.indexPathForCellController(cellController) {
            monthPickerView?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            cellController.setSelected(true)
        }
    }
    
}
}
