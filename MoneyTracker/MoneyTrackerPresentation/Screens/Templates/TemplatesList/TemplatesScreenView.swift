//
//  TemplatesScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import UIKit
import AUIKit
import PinLayout

class TemplatesScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    
    private let addTemplateTableViewCellReuseIdentifier = "addTemplateTableViewCellReuseIdentifier"
    private let templateTableViewCellReuseIdentifier = "templateTableViewCellReuseIdentifier"
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        addSubview(tableView)
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
    
    private func setupTableView() {
        tableView.register(TemplatesScreenAddTemplateTableViewCell.self, forCellReuseIdentifier: addTemplateTableViewCellReuseIdentifier)
        tableView.register(TemplateTableViewCell.self, forCellReuseIdentifier: templateTableViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.pin
            .horizontally()
            .below(of: navigationBarView)
            .bottom()
    }
    
    // MARK: - Template cell
    
    func templateTableViewCell(_ indexPath: IndexPath) -> TemplateTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: templateTableViewCellReuseIdentifier, for: indexPath) as! TemplateTableViewCell
        return cell
    }
    
    func templateTableViewCellEstimatedHeight() -> CGFloat {
        return 74
    }
    
    func templateTableViewCellHeight() -> CGFloat {
        return 74
    }
    
    // MARK: - Add template cell
    
    func addTemplateTableViewCell(_ indexPath: IndexPath) -> AddTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addTemplateTableViewCellReuseIdentifier, for: indexPath) as! TemplatesScreenAddTemplateTableViewCell
        cell.pictureImageView.image = Images.plusInDashCircle
        return cell
    }
    
    func addTemplateTableViewCellEstimatedHeight() -> CGFloat {
        return 76
    }
    
    func addTemplateTableViewCellHeight() -> CGFloat {
        return 76
    }
}
