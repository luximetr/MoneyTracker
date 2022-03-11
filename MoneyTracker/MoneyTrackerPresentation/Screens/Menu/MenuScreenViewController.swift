//
//  MenuScreenController.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 24.11.2020.
//

import UIKit
import AUIKit

final class MenuScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Initializer
    
    init(dashboardScreenViewController: UIViewController, statisticScreenViewController: UIViewController, settingsScreenViewController: UIViewController) {
        self.dashboardScreenViewController = dashboardScreenViewController
        self.statisticScreenViewController = statisticScreenViewController
        self.settingsScreenViewController = settingsScreenViewController
        super.init()
    }
    
    // MARK: View
    
    override func loadView() {
        view = MenuScreenView()
    }
    
    private var menuScreenView: MenuScreenView! {
        return view as? MenuScreenView
    }
    
    private var screenController: UIViewController?
    let dashboardScreenViewController: UIViewController
    let statisticScreenViewController: UIViewController
    let settingsScreenViewController: UIViewController
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "MenuScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuScreenView.mainTabBarItem.addTarget(self, action: #selector(dashboard), for: .touchUpInside)
        menuScreenView.statisticTabBarItem.addTarget(self, action: #selector(statistic), for: .touchUpInside)
        menuScreenView.settingsTabBarItem.addTarget(self, action: #selector(label3), for: .touchUpInside)
        dashboard()
        setContent()
    }
    
    @objc func dashboard() {
        screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        screenController?.removeFromParent()
        addChild(dashboardScreenViewController)
        menuScreenView.setMainScreenView(dashboardScreenViewController.view)
        dashboardScreenViewController.didMove(toParent: self)
        screenController = dashboardScreenViewController
    }
    
    @objc func statistic() {
        self.screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(statisticScreenViewController)
        menuScreenView.setStatisticScreenView(statisticScreenViewController.view)
        statisticScreenViewController.didMove(toParent: self)
        screenController = statisticScreenViewController
    }
    
    @objc func label3() {
        self.screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(settingsScreenViewController)
        menuScreenView.setSettingsScreenView(settingsScreenViewController.view)
        settingsScreenViewController.didMove(toParent: self)
        screenController = settingsScreenViewController
    }
    
    // MARK: Content
    
    private func setContent() {
        menuScreenView.mainTabBarItem.textLabel.text = localizer.localizeText("dashboard")
        menuScreenView.statisticTabBarItem.textLabel.text = localizer.localizeText("statistic")
        menuScreenView.settingsTabBarItem.textLabel.text = localizer.localizeText("settings")
    }
    
}
