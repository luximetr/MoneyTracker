//
//  SettingsScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

final class SettingsScreenView: TitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let tableView = UITableView()
    
    // MARK: Setup
    
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
    
    private let titleItemTableViewCellReuseIdentifier = "titleItemTableViewCellReuseIdentifier"
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(TitleItemTableViewCell.self, forCellReuseIdentifier: titleItemTableViewCellReuseIdentifier)
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
    
    // MARK: Cells
    
    func titleItemTableViewCell(_ indexPath: IndexPath) -> TitleItemTableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: titleItemTableViewCellReuseIdentifier, for: indexPath) as? TitleItemTableViewCell
        return cell
    }
    
    func titleItemTableViewCellEstimatedHeight() -> CGFloat {
        return 60
    }
    
    func titleItemTableViewCellHeight() -> CGFloat {
        return 60
    }
    
}
