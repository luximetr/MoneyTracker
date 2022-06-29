//
//  TemplatesScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import UIKit
import AUIKit
import PinLayout

class TemplatesScreenView: BackTitleRightButtonNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private var appearanceTableViewCells: [AppearanceTableViewCell] {
        tableView.visibleCells.compactMap { $0 as? AppearanceTableViewCell }
    }
    
    private let templateTableViewCellReuseIdentifier = "templateTableViewCellReuseIdentifier"
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setAppearance(appearance)
        addSubview(tableView)
        setupTableView()
        bringSubviewToFront(navigationBarView)
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        statusBarView.backgroundColor = appearance.colors.primaryBackground
        navigationBarView.backgroundColor = appearance.colors.primaryBackground
        tableView.backgroundColor = appearance.colors.primaryBackground
        appearanceTableViewCells.forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: - Template cell
    
    func templateTableViewCell(_ indexPath: IndexPath) -> TemplateTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: templateTableViewCellReuseIdentifier, for: indexPath) as! TemplateTableViewCell
        cell.setAppearance(appearance)
        return cell
    }
    
    func templateTableViewCellEstimatedHeight() -> CGFloat {
        return 74
    }
    
    func templateTableViewCellHeight() -> CGFloat {
        return 74
    }
}
