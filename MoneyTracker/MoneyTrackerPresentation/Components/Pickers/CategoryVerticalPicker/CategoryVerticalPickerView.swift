//
//  CategoryVerticalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import UIKit
import PinLayout

class CategoryVerticalPickerView: AppearanceView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupSelf()
        changeAppearance(appearance)
        addSubview(tableView)
        setupTableView()
    }
    
    private func setupSelf() {
        layer.cornerRadius = 10
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
    
    private func setupTableView() {
        tableView.layer.cornerRadius = 10
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellIdentifier)
        tableView.register(AddCell.self, forCellReuseIdentifier: addCellIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.pin.all()
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
    }
    
    // MARK: - Category cell
    
    private let categoryCellIdentifier = "categoryCellIdentifier"
    
    func createCategoryCell(indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier) ?? UITableViewCell()
    }
    
    func getCategoryCell() -> CGFloat {
        return 25
    }
    
    // MARK: - Add cell
    
    private let addCellIdentifier = "addCellIdentifier"
    
    func createAddCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: addCellIdentifier) as? AddCell else { return UITableViewCell() }
        cell.setAppearance(appearance)
        return cell
    }
    
    func getAddCellHeight() -> CGFloat {
        return 25
    }
}
