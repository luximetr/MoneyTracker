//
//  AddTemplateScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit
import PinLayout

final class AddTemplateScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let balanceAccountPickerView = BalanceAccountHorizontalPickerView()
    let addButton = TextFilledButton()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        setupAddButton()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.primaryBackground
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.primaryBackground
    }
    
    private func setupBalanceAccountPickerView() {
        
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = Colors.primaryActionBackground
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(balanceAccountPickerView)
        addSubview(addButton)
        layoutBalanceAccountPickerView()
        layoutAddButton()
    }
    
    private func layoutBalanceAccountPickerView() {
        balanceAccountPickerView.pin
            .top(to: navigationBarView.edge.bottom).marginTop(24)
            .left(24)
            .right(24)
            .height(30)
    }
    
    private func layoutAddButton() {
        addButton.pin
            .hCenter()
            .bottom(pin.safeArea).marginBottom(24)
            .width(150)
            .height(44)
    }
}
