//
//  CategoriesScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

extension CategoriesListScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.addButton = TextButton(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let addButton: TextButton
    let tableView = UITableView()
    private var categoryTableViewCells: [CategoryTableViewCell]? {
        let categoryTableViewCells = tableView.visibleCells.compactMap({ $0 as? CategoryTableViewCell })
        return categoryTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        navigationBarView.addSubview(addButton)
        setupAddButton()
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupCategoryTableViewCell()
    }
    
    private func setupAddButton() {
        addButton.setTitleColor(appearance.accent, for: .normal)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appearance.primaryBackground
        tableView.separatorStyle = .none
    }
    
    private let categoryTableViewCellReuseIdentifier = "categoryTableViewCellReuseIdentifier"
    private func setupCategoryTableViewCell() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryTableViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAddButton()
        layoutTableView()
    }
    
    private func layoutAddButton() {
        var size = navigationBarView.bounds.size
        size = addButton.sizeThatFits(size)
        let x = navigationBarView.bounds.width - size.width - 12
        let y = (navigationBarView.frame.size.height - size.height) * 0.5
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        addButton.frame = frame
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
    
    // MARK: - CategoryTableViewCell
    
    func categoryTableViewCell(_ indexPath: IndexPath) -> CategoryTableViewCell {
        let categoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: categoryTableViewCellReuseIdentifier, for: indexPath) as! CategoryTableViewCell
        categoryTableViewCell.setAppearance(appearance)
        return categoryTableViewCell
    }
    
    func categoryTableViewCellEstimatedHeight() -> CGFloat {
        return 75
    }
    
    func categoryTableViewCellHeight() -> CGFloat {
        return 75
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        setupAddButton()
        setupTableView()
        categoryTableViewCells?.forEach({ $0.setAppearance(appearance) })
        addButton.titleLabel?.font = appearance.fonts.primary(size: 17, weight: .regular)
    }

}
}
