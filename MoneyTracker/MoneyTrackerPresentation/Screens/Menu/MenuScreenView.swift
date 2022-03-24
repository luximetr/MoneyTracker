//
//  MenuScreenView.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 24.11.2020.
//

import AUIKit

extension MenuScreenViewController {
final class ScreenView: AUIView {
    
    // MARK: Subviews
    
    private var screenView: UIView?
    private let tabBarView = UIView()
    let mainTabBarItem = TabBarItem()
    let historyTabBarItem = TabBarItem()
    let statisticTabBarItem = TabBarItem()
    let settingsTabBarItem = TabBarItem()
    var tabBarItems: [TabBarItem] { [mainTabBarItem, historyTabBarItem, statisticTabBarItem, settingsTabBarItem] }
    private var selectedTabBarItem: TabBarItem?
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(tabBarView)
        setupTabBarView()
        tabBarView.addSubview(mainTabBarItem)
        mainTabBarItem.pictureImageView.image = Images.card.withRenderingMode(.alwaysTemplate)
        tabBarView.addSubview(historyTabBarItem)
        historyTabBarItem.pictureImageView.image = Images.expensesHistory.withRenderingMode(.alwaysTemplate)
        tabBarView.addSubview(statisticTabBarItem)
        statisticTabBarItem.pictureImageView.image = Images.statistic.withRenderingMode(.alwaysTemplate)
        tabBarView.addSubview(settingsTabBarItem)
        settingsTabBarItem.pictureImageView.image = Images.gear.withRenderingMode(.alwaysTemplate)
    }
    
    private func setupTabBarView() {
        tabBarView.backgroundColor = .white
        tabBarView.layer.shadowColor = Colors.black.withAlphaComponent(0.12).cgColor
        tabBarView.layer.shadowOpacity = 0.6
        tabBarView.layer.shadowRadius = 12
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: -12)
    }
    
    // MARK: Layut
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTabBarView()
        layoutTabBarItems()
        layoutScreenView()
    }
    
    private func layoutTabBarView() {
        let x: CGFloat = 0
        let height: CGFloat = 64 + safeAreaInsets.bottom
        let y = bounds.height - height
        let width = bounds.width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        tabBarView.frame = frame
    }
    
    private func layoutTabBarItems() {
        let y: CGFloat = 0
        let height = tabBarView.bounds.height - safeAreaInsets.bottom
        let width = tabBarView.bounds.width * 0.9 / CGFloat(tabBarItems.count)
        var x: CGFloat = tabBarView.bounds.width * 0.1 / 2
        for tabBarItem in tabBarItems {
            let frame = CGRect(x: x, y: y, width: width, height: height)
            x += width
            tabBarItem.frame = frame
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
}
