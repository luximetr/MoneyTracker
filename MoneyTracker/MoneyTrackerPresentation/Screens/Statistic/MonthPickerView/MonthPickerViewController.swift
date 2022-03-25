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
    
    let months: [Date]
    
    // MARK: Initializer
    
    init(months: [Date]) {
        self.months = months
        super.init()
    }
    
    // MARK: MonthPickerView
  
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
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    
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
        let cellController = MonthCollectionViewCellController(month: month)
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
            self.didSelectMonth(cellController)
        }
        return cellController
    }
    
    private var selectedCellController: MonthCollectionViewCellController?
    private func didSelectMonth(_ cellController: MonthCollectionViewCellController) {
        guard selectedCellController !== cellController else { return }
        selectedCellController?.isSelected = false
        selectedCellController = cellController
        if let indexPath = collectionViewController.indexPathForCellController(cellController) {
            monthPickerView?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            cellController.isSelected = true
        }
    }
    
}
}
