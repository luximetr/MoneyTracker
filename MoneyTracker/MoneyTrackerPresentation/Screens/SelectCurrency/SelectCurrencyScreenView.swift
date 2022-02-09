//
//  SelectCurrencyScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.02.2022.
//

import UIKit
import AUIKit

class SelectCurrencyScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.primaryBackground
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.primaryBackground
    }
    
    private let selectCurrencyTableViewCellReuseIdentifier = "selectCurrencyTableViewCellReuseIdentifier"
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(SelectCurrencyTableViewCell.self, forCellReuseIdentifier: selectCurrencyTableViewCellReuseIdentifier)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTableView()
    }
    
    private func layoutTableView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        tableView.frame = frame
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Cells
    
    func makeSelectCurrencyCell(_ indexPath: IndexPath) -> SelectCurrencyTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: selectCurrencyTableViewCellReuseIdentifier, for: indexPath) as! SelectCurrencyTableViewCell
        return cell
    }
    
    func getSelectCurrencyTableViewCellEstimatedHeight() -> CGFloat {
        return 44
    }
    
    func getSelectCurrencyTableViewCellHeight() -> CGFloat {
        return 44
    }
}
