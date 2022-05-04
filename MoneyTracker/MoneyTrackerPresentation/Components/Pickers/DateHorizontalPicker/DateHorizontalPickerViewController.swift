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
    
    var didSelectDateClosure: ((Date) -> Void)?
    
    // MARK: - Initializer
    
    // MARK: - View
    
    var pickerView: DateHorizontalPickerView? {
        get { return view as? DateHorizontalPickerView }
        set { view = newValue }
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        setupCollectionViewController()
        reloadDates()
    }
    
    override func unsetupView() {
        super.unsetupView()
        collectionViewController.collectionView = nil
    }
    
    // MARK: - Content
    
    private lazy var localizer: ScreenLocalizer = {
        return ScreenLocalizer(language: language, stringsTableName: "DateHorizontalPickerViewStrings")
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        findTodayCellController()?.setTitle(localizer.localizeText("today"))
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
    
    // MARK: - Collection view controller
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    
    private func setupCollectionViewController() {
        collectionViewController.collectionView = pickerView?.collectionView
        collectionViewController.scrollViewDidEndDraggingClosure = { [weak self] willDecelerate in
            guard willDecelerate == false else { return }
            self?.scrollToNearestDate()
        }
        collectionViewController.scrollViewDidEndDeceleratingClosure = { [weak self] in
            self?.scrollToNearestDate()
        }
    }
    
    // MARK: - Date cells
    
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
        let isToday = calendar.isDateInToday(date)
        let title = isToday ? localizer.localizeText("today") : dateFormatter.string(from: date)
        let controller = DateCellController(date: date, title: title)
        controller.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            return self?.pickerView?.createDateCell(indexPath: indexPath) ?? UICollectionViewCell()
        }
        controller.sizeForCellClosure = { [weak self] in
            return self?.pickerView?.getDateCellSize() ?? .zero
        }
        controller.didSelectClosure = { [weak self, weak controller] in
            guard let controller = controller else { return }
            self?.didSelectDateCell(cellController: controller)
        }
        return controller
    }
    
    // MARK: - Date cell - Find
    
    private func findDateCells() -> [DateCellController] {
        return sectionController.cellControllers.compactMap { $0 as? DateCellController }
    }
    
    private func findTodayCellController() -> DateCellController? {
        return findDateCells().first(where: { calendar.isDateInToday($0.date) })
    }
    
    private func findIndexPath(cellController: DateCellController) -> IndexPath? {
        let index = sectionController.cellControllers.firstIndex(where: { $0 === cellController })
        guard let index = index else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    private func findDateCellController(indexPath: IndexPath) -> DateCellController? {
        return sectionController.cellControllers[safe: indexPath.row] as? DateCellController
    }
    
    private func findDateCellController(date: Date) -> DateCellController? {
        return findDateCells().first(where: { calendar.isDate(date, inSameDayAs: $0.date) })
    }
    
    // MARK: - Date cell - Select
    
    private func didSelectDateCell(cellController: DateCellController) {
        guard let indexPath = findIndexPath(cellController: cellController) else { return }
        pickerView?.showSelected(indexPath: indexPath)
        selectedDate = cellController.date
        didSelectDateClosure?(selectedDate)
    }
    
    private func scrollToNearestDate() {
        guard let indexPath = pickerView?.findNearestCellIndexPathUnderSelectedDayFrameView() else { return }
        guard let dateCellController = findDateCellController(indexPath: indexPath) else { return }
        pickerView?.showSelected(indexPath: indexPath)
        selectedDate = dateCellController.date
        didSelectDateClosure?(selectedDate)
    }
    
    func setSelectedDate(_ date: Date) {
        self.selectedDate = date
        guard let dateCellController = findDateCellController(date: date) else { return }
        guard let indexPath = findIndexPath(cellController: dateCellController) else { return }
        pickerView?.showSelected(indexPath: indexPath)
    }
}
