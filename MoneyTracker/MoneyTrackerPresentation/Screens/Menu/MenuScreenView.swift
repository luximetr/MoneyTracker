//
//  MenuScreenView.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 24.11.2020.
//

import AUIKit

final class MenuScreenView: AUIView {
    
    // MARK: Subviews
    
    private var screenView: UIView?
    private let tabBarView = UIView()
    let mainTabBarItem = MenuScreenTabBarItem()
    let historyTabBarItem = MenuScreenTabBarItem()
    let statisticTabBarItem = MenuScreenTabBarItem()
    let settingsTabBarItem = MenuScreenTabBarItem()
    private var selectedTabBarItem: MenuScreenTabBarItem?
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(tabBarView)
        setuptTabBarView()
    }
    
    private func setuptTabBarView() {
        tabBarView.backgroundColor = .white
        tabBarView.layer.shadowColor = Colors.black.withAlphaComponent(0.12).cgColor
        tabBarView.layer.shadowOpacity = 0.6
        tabBarView.layer.shadowRadius = 12
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: -12)
        tabBarView.addSubview(mainTabBarItem)
        mainTabBarItem.pictureImageView.image = Images.card.withRenderingMode(.alwaysTemplate)
        tabBarView.addSubview(historyTabBarItem)
        historyTabBarItem.pictureImageView.image = Images.expensesHistory.withRenderingMode(.alwaysTemplate)
        tabBarView.addSubview(statisticTabBarItem)
        statisticTabBarItem.pictureImageView.image = Images.statistic.withRenderingMode(.alwaysTemplate)
        tabBarView.addSubview(settingsTabBarItem)
        settingsTabBarItem.pictureImageView.image = Images.gear.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: Layut
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTabBarView()
        layoutScreenView()
    }
    
    private func layoutTabBarView() {
        let x: CGFloat = 0
        var height: CGFloat = 64
        if #available(iOS 11.0, *) { height += safeAreaInsets.bottom }
        let y = bounds.height - height
        let width = bounds.width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        tabBarView.frame = frame
        var itemHeight = tabBarView.bounds.height
        if #available(iOS 11.0, *) { itemHeight -= safeAreaInsets.bottom }
        let items = [mainTabBarItem, historyTabBarItem, statisticTabBarItem, settingsTabBarItem]
        let itemWidth = tabBarView.bounds.width * 0.9 / CGFloat(items.count)
        var itemX: CGFloat = tabBarView.bounds.width * 0.1 / 2
        let itemY: CGFloat = 0
        for item in items {
            let frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            itemX += itemWidth
            item.frame = frame
        }
    }
    
    private func layoutScreenView() {
        if let screenView = screenView {
            let x: CGFloat = 0
            let y: CGFloat = 0
            let width = bounds.width
            let height = bounds.height - tabBarView.bounds.height
            let frame = CGRect(x: x, y: y, width: width, height: height)
            screenView.frame = frame
        }
    }
    
    // MARK: Setters
    
    func setMainScreenView(_ homeScreenView: UIView) {
        selectedTabBarItem?.isSelected = false
        selectedTabBarItem = mainTabBarItem
        mainTabBarItem.isSelected = true
        setScreenView(homeScreenView)
    }
    
    func setHistoryScreenView(_ historyScreenView: UIView) {
        selectedTabBarItem?.isSelected = false
        selectedTabBarItem = historyTabBarItem
        historyTabBarItem.isSelected = true
        setScreenView(historyScreenView)
    }
    
    func setStatisticScreenView(_ homeScreenView: UIView) {
        selectedTabBarItem?.isSelected = false
        selectedTabBarItem = statisticTabBarItem
        statisticTabBarItem.isSelected = true
        setScreenView(homeScreenView)
    }
    
    func setSettingsScreenView(_ homeScreenView: UIView) {
        selectedTabBarItem?.isSelected = false
        selectedTabBarItem = settingsTabBarItem
        settingsTabBarItem.isSelected = true
        setScreenView(homeScreenView)
    }
    
    func setScreenView(_ screenView: UIView?) {
        self.screenView?.removeFromSuperview()
        if let screenView = screenView {
            self.screenView = screenView
            insertSubview(screenView, belowSubview: tabBarView)
        }
    }
    
}
