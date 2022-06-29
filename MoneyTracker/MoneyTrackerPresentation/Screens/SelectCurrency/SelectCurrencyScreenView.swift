//
//  SelectCurrencyScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.02.2022.
//

import UIKit
import AUIKit

extension SelectCurrencyScreenViewController {
class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.colors.primaryBackground
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupCurrencyTableViewCell()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appearance.colors.primaryBackground
        tableView.separatorStyle = .none
    }
    
    private let currencyTableViewCellReuseIdentifier = "currencyTableViewCellReuseIdentifier"
    private func setupCurrencyTableViewCell() {
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: currencyTableViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - CurrencyTableViewCell
    
    func currencyTableViewCell(_ indexPath: IndexPath) -> CurrencyTableViewCell {
        let currencyTableViewCell = tableView.dequeueReusableCell(withIdentifier: currencyTableViewCellReuseIdentifier, for: indexPath) as! CurrencyTableViewCell
        return currencyTableViewCell
    }
    
    func currencyTableViewCellEstimatedHeight() -> CGFloat {
        return 44
    }
    
    func currencyTableViewCellHeight() -> CGFloat {
        return 44
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        setupTableView()
    }
    
}
}
