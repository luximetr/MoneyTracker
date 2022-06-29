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
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupLanguageTableViewCell()
        setAppearance(appearance)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    private let languageTableViewCellReuseIdentifier = "languageTableViewCellReuseIdentifier"
    private func setupLanguageTableViewCell() {
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - LanguageTableViewCell
    
    func languageTableViewCell(_ indexPath: IndexPath) -> LanguageTableViewCell {
        let languageTableViewCell = tableView.dequeueReusableCell(withIdentifier: languageTableViewCellReuseIdentifier, for: indexPath) as! LanguageTableViewCell
        return languageTableViewCell
    }
    
    func languageTableViewCellEstimatedHeight() -> CGFloat {
        return 44
    }
    
    func languageTableViewCellHeight() -> CGFloat {
        return 44
    }
    
    // MARK: Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        tableView.backgroundColor = appearance.colors.primaryBackground
    }
    
}
}
