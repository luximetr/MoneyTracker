//
//  MenuScreenController.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 24.11.2020.
//

import UIKit
import AUIKit

final class MenuScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Initializer
    
    init(appearance: Appearance, language: Language, dashboardScreenViewController: UIViewController, historyScreenViewController: UIViewController, statisticScreenViewController: UIViewController, settingsScreenViewController: UIViewController) {
        self.dashboardScreenViewController = dashboardScreenViewController
        self.historyScreenViewController = historyScreenViewController
        self.statisticScreenViewController = statisticScreenViewController
        self.settingsScreenViewController = settingsScreenViewController
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    private var screenController: UIViewController?
    let dashboardScreenViewController: UIViewController
    let historyScreenViewController: UIViewController
    let statisticScreenViewController: UIViewController
    let settingsScreenViewController: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.mainTabBarItem.addTarget(self, action: #selector(dashboard), for: .touchUpInside)
        screenView.historyTabBarItem.addTarget(self, action: #selector(history), for: .touchUpInside)
        screenView.statisticTabBarItem.addTarget(self, action: #selector(statistic), for: .touchUpInside)
        screenView.settingsTabBarItem.addTarget(self, action: #selector(settings), for: .touchUpInside)
        dashboard()
        setContent()
    }
    
    // MARK: - Events
    
    @objc func dashboard() {
        screenController?.willMove(toParent: nil)
        screenView.setScreenView(nil)
        screenController?.removeFromParent()
        addChild(dashboardScreenViewController)
        screenView.setMainScreenView(dashboardScreenViewController.view)
        dashboardScreenViewController.didMove(toParent: self)
        screenController = dashboardScreenViewController
    }
    
    @objc func history() {
        screenController?.willMove(toParent: nil)
        screenView.setScreenView(nil)
        screenController?.removeFromParent()
        addChild(historyScreenViewController)
        screenView.setHistoryScreenView(historyScreenViewController.view)
        historyScreenViewController.didMove(toParent: self)
        screenController = historyScreenViewController
    }
    
    @objc func statistic() {
        self.screenController?.willMove(toParent: nil)
        screenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(statisticScreenViewController)
        screenView.setStatisticScreenView(statisticScreenViewController.view)
        statisticScreenViewController.didMove(toParent: self)
        screenController = statisticScreenViewController
    }
    
    @objc func settings() {
        self.screenController?.willMove(toParent: nil)
        screenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(settingsScreenViewController)
        screenView.setSettingsScreenView(settingsScreenViewController.view)
        settingsScreenViewController.didMove(toParent: self)
        screenController = settingsScreenViewController
    }
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        localizer.changeLanguage(language)
        setContent()
    }
    
    // MARK: - Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "MenuScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.mainTabBarItem.textLabel.text = localizer.localizeText("dashboard")
        screenView.historyTabBarItem.textLabel.text = localizer.localizeText("history")
        screenView.statisticTabBarItem.textLabel.text = localizer.localizeText("statistic")
        screenView.settingsTabBarItem.textLabel.text = localizer.localizeText("settings")
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
    
}
