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
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private var appearanceTableViewCells: [AppearanceTableViewCell] {
        tableView.visibleCells.compactMap { $0 as? AppearanceTableViewCell }
    }
    
    private let addTemplateTableViewCellReuseIdentifier = "addTemplateTableViewCellReuseIdentifier"
    private let templateTableViewCellReuseIdentifier = "templateTableViewCellReuseIdentifier"
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        changeAppearance(appearance)
        addSubview(tableView)
        setupTableView()
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
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        statusBarView.backgroundColor = appearance.primaryBackground
        navigationBarView.backgroundColor = appearance.primaryBackground
        tableView.backgroundColor = appearance.primaryBackground
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
