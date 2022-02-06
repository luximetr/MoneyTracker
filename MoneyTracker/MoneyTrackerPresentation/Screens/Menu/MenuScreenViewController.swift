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
    
    init(mainScreenViewController: UIViewController, categoriesScreenViewController: UIViewController, settingsScreenViewController: UIViewController) {
        self.mainScreenViewController = mainScreenViewController
        self.categoriesScreenViewController = categoriesScreenViewController
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
    let mainScreenViewController: UIViewController
    let categoriesScreenViewController: UIViewController
    let settingsScreenViewController: UIViewController
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "MenuScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuScreenView.mainTabBarItem.addTarget(self, action: #selector(main), for: .touchUpInside)
        menuScreenView.statisticTabBarItem.addTarget(self, action: #selector(categories), for: .touchUpInside)
        menuScreenView.settingsTabBarItem.addTarget(self, action: #selector(label3), for: .touchUpInside)
        main()
        setContent()
    }
    
    @objc private func main() {
        screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        screenController?.removeFromParent()
        addChild(mainScreenViewController)
        menuScreenView.setMainScreenView(mainScreenViewController.view)
        mainScreenViewController.didMove(toParent: self)
        screenController = mainScreenViewController
    }
    
    @objc func categories() {
        self.screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(categoriesScreenViewController)
        menuScreenView.setStatisticScreenView(categoriesScreenViewController.view)
        categoriesScreenViewController.didMove(toParent: self)
        screenController = categoriesScreenViewController
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
        menuScreenView.mainTabBarItem.textLabel.text = localizer.localizeText("main")
        menuScreenView.statisticTabBarItem.textLabel.text = localizer.localizeText("statistic")
        menuScreenView.settingsTabBarItem.textLabel.text = localizer.localizeText("settings")
    }
    
}
