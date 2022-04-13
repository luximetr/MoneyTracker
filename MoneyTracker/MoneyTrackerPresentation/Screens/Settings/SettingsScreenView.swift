//
//  SettingsScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

extension SettingsScreenViewController {
final class ScreenView: TitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.white
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.white
    }
    
    private let titleTableViewCellReuseIdentifier = "titleTableViewCellReuseIdentifier"
    private let titleValueTableViewCellReuseIdentifier = "titleValueTableViewCellReuseIdentifier"
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: titleTableViewCellReuseIdentifier)
        tableView.register(TitleValueTableViewCell.self, forCellReuseIdentifier: titleValueTableViewCellReuseIdentifier)
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
    
    // MARK: - TitleTableViewCell
    
    func titleTableViewCell(_ indexPath: IndexPath) -> TitleTableViewCell {
        let titleTableViewCell = tableView.dequeueReusableCell(withIdentifier: titleTableViewCellReuseIdentifier, for: indexPath) as! TitleTableViewCell
        return titleTableViewCell
    }
    
    func titleTableViewCellEstimatedHeight() -> CGFloat {
        return 60
    }
    
    func titleTableViewCellHeight() -> CGFloat {
        return 60
    }
    
    // MARK: - TitleValueTableViewCell
    
    func titleValueTableViewCell(_ indexPath: IndexPath) -> TitleValueTableViewCell {
        let titleValueTableViewCell = tableView.dequeueReusableCell(withIdentifier: titleValueTableViewCellReuseIdentifier, for: indexPath) as! TitleValueTableViewCell
        return titleValueTableViewCell
    }
    
    func titleValueTableViewCellEstimatedHeight() -> CGFloat {
        return 60
    }
    
    func titleValueTableViewCellHeight() -> CGFloat {
        return 60
    }
    
}
}
