//
//  SelectLanguageScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import UIKit
import AUIKit

extension SelectLanguageScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
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
    
    private let languageTableViewCellReuseIdentifier = "languageTableViewCellReuseIdentifier"
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(LanguageTableViewCell.self, forCellReuseIdentifier: languageTableViewCellReuseIdentifier)
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
    
    // MARK: - LanguageTableViewCell
    
    func languageTableViewCell(_ indexPath: IndexPath) -> LanguageTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: languageTableViewCellReuseIdentifier, for: indexPath) as! LanguageTableViewCell
        return cell
    }
    
    func languageTableViewCellEstimatedHeight() -> CGFloat {
        return 44
    }
    
    func languageTableViewCellHeight() -> CGFloat {
        return 44
    }
}
}
