//
//  StatisticScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import UIKit
import AUIKit
import PinLayout

final class StatisticScreenView: TitleNavigationBarScreenView {
    
    // MARK: - UI elements
    
    let fromDateLabel = UILabel()
    let fromDateButton = UIButton()
    let toDateLabel = UILabel()
    let toDateButton = UIButton()
    let resultLabel = UILabel()
    let datePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    let searchButton = UIButton()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        toDatePicker.preferredDatePickerStyle = .compact
        toDatePicker.datePickerMode = .date
        searchButton.setTitleColor(.blue, for: .normal)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(fromDateLabel)
        addSubview(fromDateButton)
        addSubview(toDateLabel)
        addSubview(toDateButton)
        addSubview(datePicker)
        addSubview(toDatePicker)
        addSubview(resultLabel)
        addSubview(searchButton)
        pinFromDateLabel()
        pinToDateLabel()
        pinFromDateButton()
        pinToDateButton()
        pinDatePicker()
        pinToDatePicker()
        pinResultLabel()
        pinSearchButton()
    }
    
    private func pinFromDateLabel() {
        fromDateLabel.pin
            .top(to: navigationBarView.edge.bottom).marginTop(20)
            .left(20)
            .sizeToFit()
    }
    
    private func pinToDateLabel() {
        toDateLabel.pin
            .top(to: fromDateLabel.edge.top)
            .right(20)
            .sizeToFit()
    }
    
    private func pinFromDateButton() {
        fromDateButton.pin
            .left(to: fromDateLabel.edge.left)
            .right(to: fromDateLabel.edge.right)
            .height(40)
            .vCenter(to: fromDateLabel.edge.vCenter)
    }
    
    private func pinToDateButton() {
        toDateButton.pin
            .left(to: toDateLabel.edge.left)
            .right(to: toDateLabel.edge.right)
            .height(40)
            .vCenter(to: toDateLabel.edge.vCenter)
    }
    
    private func pinDatePicker() {
        datePicker.pin
            .left(20)
            .top(200)
            .sizeToFit()
    }
    
    private func pinToDatePicker() {
        toDatePicker.pin
            .right(20)
            .top(250)
            .sizeToFit()
    }
    
    private func pinResultLabel() {
        resultLabel.pin
            .left(20)
            .top(to: fromDateLabel.edge.bottom).marginTop(150)
            .sizeToFit()
    }
    
    private func pinSearchButton() {
        searchButton.pin
            .bottom(pin.safeArea).marginBottom(40)
            .hCenter()
            .height(44)
            .sizeToFit(.height)
    }
}
