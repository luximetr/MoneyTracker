//
//  StatisticScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import UIKit
import AUIKit

final class StatisticScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Delegations
    
    var didPressSearch: ((_ fromDate: Date, _ toDate: Date) -> Void)?
    
    // MARK: - Data
    
    private var fromDate = Date()
    private var toDate = Date()
    
    // MARK: - View
    
    private var statisticScreenView: StatisticScreenView {
        return view as! StatisticScreenView
    }
    
    override func loadView() {
        view = StatisticScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticScreenView.titleLabel.text = "Statistic"
        statisticScreenView.fromDateLabel.text = "01.01.2022"
        statisticScreenView.toDateLabel.text = "31.01.2022"
        statisticScreenView.fromDateButton.addTarget(self, action: #selector(didTapOnFromDateButton), for: .touchUpInside)
        statisticScreenView.toDateButton.addTarget(self, action: #selector(didTapOnToDateButton), for: .touchUpInside)
        statisticScreenView.resultLabel.text = "Result: "
        statisticScreenView.searchButton.setTitle("Search", for: .normal)
        statisticScreenView.searchButton.addTarget(self, action: #selector(didTapOnSearchButton), for: .touchUpInside)
        statisticScreenView.datePicker.addTarget(self, action: #selector(fromDatePickerDateChanged), for: .valueChanged)
        statisticScreenView.toDatePicker.addTarget(self, action: #selector(toDatePickerDateChanged), for: .valueChanged)
    }
    
    @objc
    private func didTapOnFromDateButton() {
    }
    
    @objc
    private func didTapOnToDateButton() {
    }
    
    @objc
    private func didTapOnSearchButton() {
        didPressSearch?(fromDate, toDate)
    }
    
    @objc
    private func fromDatePickerDateChanged() {
        fromDate = statisticScreenView.datePicker.date
    }
    
    @objc
    private func toDatePickerDateChanged() {
        toDate = statisticScreenView.toDatePicker.date
    }
    
    func showResult(_ result: Decimal) {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        guard let string = numberFormatter.string(from: NSDecimalNumber(decimal: result)) else { return }
        statisticScreenView.resultLabel.text = string + " SGD"
        statisticScreenView.layoutSubviews()
    }
}
