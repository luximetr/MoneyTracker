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
    
    init(appearance: Appearance, locale: Locale, dashboardScreenViewController: UIViewController, statisticScreenViewController: UIViewController, settingsScreenViewController: UIViewController) {
        self.dashboardScreenViewController = dashboardScreenViewController
        self.statisticScreenViewController = statisticScreenViewController
        self.settingsScreenViewController = settingsScreenViewController
        super.init(appearance: appearance, locale: locale)
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
    let statisticScreenViewController: UIViewController
    let settingsScreenViewController: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.mainTabBarItem.addTarget(self, action: #selector(dashboard), for: .touchUpInside)
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
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        localizer.changeLanguage(locale.language)
        setContent()
    }
    
    // MARK: - Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: locale.language, stringsTableName: "MenuScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.mainTabBarItem.textLabel.text = localizer.localizeText("dashboard")
        screenView.statisticTabBarItem.textLabel.text = localizer.localizeText("statistic")
        screenView.settingsTabBarItem.textLabel.text = localizer.localizeText("settings")
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
    
}
