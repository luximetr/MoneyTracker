//
//  SelectAppearanceScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import UIKit
import AUIKit

extension SelectAppearanceScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private var languageTableViewCells: [AppearanceSettingTableViewCell]? {
        let languageTableViewCells = tableView.visibleCells.compactMap({ $0 as? AppearanceSettingTableViewCell })
        return languageTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupAppearanceSettingTableViewCell()
        changeAppearance(appearance)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    private let appearanceSettingTableViewCellReuseIdentifier = "appearanceSettingTableViewCellReuseIdentifier"
    private func setupAppearanceSettingTableViewCell() {
        tableView.register(AppearanceSettingTableViewCell.self, forCellReuseIdentifier: appearanceSettingTableViewCellReuseIdentifier)
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - AppearanceSettingTableViewCell
    
    func appearanceSettingTableViewCell(_ indexPath: IndexPath) -> AppearanceSettingTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: appearanceSettingTableViewCellReuseIdentifier, for: indexPath) as! AppearanceSettingTableViewCell
        return cell
    }
    
    func appearanceSettingTableViewCellEstimatedHeight() -> CGFloat {
        return 60
    }
    
    func appearanceSettingTableViewCellHeight() -> CGFloat {
        return 60
    }
    
    // MARK: Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        tableView.backgroundColor = appearance.primaryBackground
    }
    
}
}
