//
//  DateHorizontalPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.05.2022.
//

import AUIKit

class DateHorizontalPickerViewController: EmptyViewController {
    
    // MARK: - Data
    
    private(set) var selectedDate: Date = Date()
    
    // MARK: - Delegations
    
    // MARK: - Initializer
    
    // MARK: - View
    
    var pickerView: DateHorizontalPickerView? {
        get { return view as? DateHorizontalPickerView }
        set { view = newValue }
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        collectionViewController.collectionView = pickerView?.collectionView
        reloadDates()
    }
    
    override func unsetupView() {
        super.unsetupView()
        collectionViewController.collectionView = nil
    }
    
    // MARK: - Dates
    
    private func reloadDates() {
        let dates = createDates()
        showDates(dates)
    }
    
    private let calendar = Calendar.current
    
    private func createDates() -> [Date] {
        let todayDate = Date()
        var dates: [Date] = []
        for dateOffset in 0...31 {
            guard let date = calendar.date(byAdding: .day, value: -dateOffset, to: todayDate) else { continue }
            dates.append(date)
        }
        return dates
    }
    
    // MARK: - Date cells
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    
    private func showDates(_ dates: [Date]) {
        let cellControllers = createDatesCellControllers(dates: dates)
        sectionController.cellControllers = cellControllers
        collectionViewController.sectionControllers = [sectionController]
        collectionViewController.reload()
    }
    
    private func createDatesCellControllers(dates: [Date]) -> [DateCellController] {
        return dates.map { createDateCellController(date: $0) }
    }
    
    // MARK: - Date cell - Create
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM."
        return formatter
    }()
    
    private func createDateCellController(date: Date) -> DateCellController {
        let controller = DateCellController(title: dateFormatter.string(from: date))
        controller.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            return self?.pickerView?.createDateCell(indexPath: indexPath) ?? UICollectionViewCell()
        }
        controller.sizeForCellClosure = { [weak self] in
            return self?.pickerView?.getDateCellSize() ?? .zero
        }
        controller.didSelectClosure = { [weak self] in
            self?.didSelectDateCell(date: date)
        }
        return controller
    }
    
    // MARK: - Date cell - Select
    
    private func didSelectDateCell(date: Date) {
        
    }
}
