//
//  TotalAmountViewSettingScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import UIKit
import AUIKit

extension TotalAmountViewSettingsScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private var totalAmountViewSettingTableViewCells: [TotalAmountViewSettingTableViewCell]? {
        let totalAmountViewSettingTableViewCells = tableView.visibleCells.compactMap({ $0 as? TotalAmountViewSettingTableViewCell })
        return totalAmountViewSettingTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupAppearanceSettingTableViewCell()
        setAppearance(appearance)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    private let appearanceSettingTableViewCellReuseIdentifier = "appearanceSettingTableViewCellReuseIdentifier"
    private func setupAppearanceSettingTableViewCell() {
        tableView.register(TotalAmountViewSettingTableViewCell.self, forCellReuseIdentifier: appearanceSettingTableViewCellReuseIdentifier)
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
    
    func appearanceSettingTableViewCell(_ indexPath: IndexPath) -> TotalAmountViewSettingTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: appearanceSettingTableViewCellReuseIdentifier, for: indexPath) as! TotalAmountViewSettingTableViewCell
        return cell
    }
    
    func appearanceSettingTableViewCellEstimatedHeight() -> CGFloat {
        return 60
    }
    
    func appearanceSettingTableViewCellHeight() -> CGFloat {
        return 60
    }
    
    // MARK: Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        tableView.backgroundColor = appearance.colors.primaryBackground
    }
    
}
}
