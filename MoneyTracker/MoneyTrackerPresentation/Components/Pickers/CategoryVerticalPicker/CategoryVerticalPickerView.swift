//
//  CategoryVerticalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import UIKit
import PinLayout

class CategoryVerticalPickerView: AppearanceView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private let topGradientViewLayer = CAGradientLayer()
    let topGradientView = UIView()
    let selectionDividerView = UIView()
    let transparentView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupSelf()
        changeAppearance(appearance)
        addSubview(tableView)
        setupTableView()
        addSubview(topGradientView)
        setupTopGradientView()
        addSubview(selectionDividerView)
        addSubview(transparentView)
        setupTransparentView()
    }
    
    private func setupSelf() {
        layer.cornerRadius = 10
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
    
    private func setupTableView() {
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 17, left: 0, bottom: transparentView.frame.height + 8, right: 0)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellIdentifier)
        tableView.register(AddCell.self, forCellReuseIdentifier: addCellIdentifier)
    }
    
    private func setupTopGradientView() {
        topGradientViewLayer.startPoint = CGPoint(x: 0.5, y: 1)
        topGradientViewLayer.endPoint = CGPoint(x: 0.5, y: 0)
        topGradientView.layer.insertSublayer(topGradientViewLayer, at: 0)
        topGradientView.layer.cornerRadius = 10
        topGradientView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topGradientView.layer.masksToBounds = true
        topGradientView.isUserInteractionEnabled = false
    }
    
    private func setupTransparentView() {
        transparentView.alpha = 0.4
        transparentView.isUserInteractionEnabled = false
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTableView()
        layoutTopGradientView()
        layoutSelectionDividerView()
        layoutTransparentView()
        tableView.contentInset = UIEdgeInsets(top: 17, left: 0, bottom: transparentView.frame.height + 8, right: 0)
    }
    
    private func layoutTableView() {
        tableView.pin.all()
    }
    
    private func layoutTopGradientView() {
        topGradientView.pin
            .left()
            .right()
            .top()
            .height(25)
        topGradientViewLayer.frame = topGradientView.bounds
    }
    
    private func layoutSelectionDividerView() {
        selectionDividerView.pin
            .left(15)
            .right()
            .top(53)
            .height(1)
    }
    
    private func layoutTransparentView() {
        transparentView.pin
            .left()
            .right()
            .top(to: selectionDividerView.edge.bottom)
            .bottom()
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        tableView.backgroundColor = appearance.primaryBackground
        topGradientViewLayer.colors = [appearance.transparent.cgColor, appearance.primaryBackground.cgColor]
        selectionDividerView.backgroundColor = appearance.tertiaryBackground
        transparentView.backgroundColor = appearance.primaryBackground
    }
    
    // MARK: - TableView - Scroll
    
    func scrollToCell(at indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // MARK: - Category cell
    
    private let categoryCellIdentifier = "categoryCellIdentifier"
    
    func createCategoryCell(indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier) ?? UITableViewCell()
    }
    
    func getCategoryCell() -> CGFloat {
        return 35
    }
    
    // MARK: - Add cell
    
    private let addCellIdentifier = "addCellIdentifier"
    
    func createAddCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: addCellIdentifier) as? AddCell else { return UITableViewCell() }
        cell.setAppearance(appearance)
        return cell
    }
    
    func getAddCellHeight() -> CGFloat {
        return 25
    }
}
