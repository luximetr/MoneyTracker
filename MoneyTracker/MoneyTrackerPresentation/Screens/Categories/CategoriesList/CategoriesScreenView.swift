//
//  CategoriesScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

extension CategoriesScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
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
    
    private let categoryTableViewCellReuseIdentifier = "categoryTableViewCellReuseIdentifier"
    private let addCategoryTableViewCellReuseIdentifier = "addCategoryTableViewCellReuseIdentifier"
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryTableViewCellReuseIdentifier)
        tableView.register(AddTableViewCell.self, forCellReuseIdentifier: addCategoryTableViewCellReuseIdentifier)
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
    
    // MARK: CategoryTableViewCell
    
    func categoryTableViewCell(_ indexPath: IndexPath) -> CategoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryTableViewCellReuseIdentifier, for: indexPath) as! CategoryTableViewCell
        return cell
    }
    
    func categoryTableViewCellEstimatedHeight() -> CGFloat {
        return 75
    }
    
    func categoryTableViewCellHeight() -> CGFloat {
        return 75
    }
    
    // MARK: AddCategoryTableViewCell
    
    func addCategoryTableViewCell(_ indexPath: IndexPath) -> AddTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addCategoryTableViewCellReuseIdentifier, for: indexPath) as! AddTableViewCell
        cell.pictureImageView.image = Images.plusInDashCircle
        return cell
    }
    
    func addCategoryTableViewCellEstimatedHeight() -> CGFloat {
        return 75
    }
    
    func addCategoryTableViewCellHeight() -> CGFloat {
        return 75
    }
    
}
}
