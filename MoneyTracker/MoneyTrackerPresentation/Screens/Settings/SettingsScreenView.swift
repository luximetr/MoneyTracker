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
    
    // MARK: - Initialization
        
    init(appearance: Appearance) {
        super.init(appearance: appearance)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        setupTitleLabel()
        setupTableView()
        titleTableViewCells?.forEach({ $0.setAppearance(appearance) })
        titleValueTableViewCells?.forEach({ $0.setAppearance(appearance) })
    }
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private var titleTableViewCells: [TitleTableViewCell]? {
        let titleTableViewCells = tableView.visibleCells.compactMap({ $0 as? TitleTableViewCell })
        return titleTableViewCells
    }
    private var titleValueTableViewCells: [TitleValueTableViewCell]? {
        let titleValueTableViewCells = tableView.visibleCells.compactMap({ $0 as? TitleValueTableViewCell })
        return titleValueTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupTitleTableViewCell()
        setupTitleValueTableViewCell()
    }
    
    override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.textColor = appearance.colors.primaryText
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appearance.colors.primaryBackground
        tableView.separatorStyle = .none
    }
    
    private let titleTableViewCellReuseIdentifier = "titleTableViewCellReuseIdentifier"
    private func setupTitleTableViewCell() {
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: titleTableViewCellReuseIdentifier)
    }
    
    private let titleValueTableViewCellReuseIdentifier = "titleValueTableViewCellReuseIdentifier"
    private func setupTitleValueTableViewCell() {
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
        titleTableViewCell.setAppearance(appearance)
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
        titleValueTableViewCell.setAppearance(appearance)
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
