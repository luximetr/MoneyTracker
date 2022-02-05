//
//  CategoriesScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesScreenView: TitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let tableView = UITableView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        addSubview(tableView)
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
        tableView.register(CategoriesScreenCategoryTableViewCell.self, forCellReuseIdentifier: categoryTableViewCellReuseIdentifier)
        tableView.register(CategoriesScreenAddCategoryTableViewCell.self, forCellReuseIdentifier: addCategoryTableViewCellReuseIdentifier)
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
    }
    
    // MARK: Cells
    
    func categoryTableViewCell(_ indexPath: IndexPath) -> CategoriesScreenCategoryTableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryTableViewCellReuseIdentifier, for: indexPath) as? CategoriesScreenCategoryTableViewCell
        return cell
    }
    
    func categoryTableViewCellEstimatedHeight() -> CGFloat {
        return 76
    }
    
    func categoryTableViewCellHeight() -> CGFloat {
        return 76
    }
    
    func addCategoryTableViewCell(_ indexPath: IndexPath) -> CategoriesScreenAddCategoryTableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: addCategoryTableViewCellReuseIdentifier, for: indexPath) as? CategoriesScreenAddCategoryTableViewCell
        cell?.pictureImageView.image = Images.plusInDashCircle
        return cell
    }
    
    func addCategoryTableViewCellEstimatedHeight() -> CGFloat {
        return 76
    }
    
    func addCategoryTableViewCellHeight() -> CGFloat {
        return 76
    }
    
}
