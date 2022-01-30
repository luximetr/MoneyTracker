//
//  MenuScreenController.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 24.11.2020.
//

import UIKit
import AUIKit

class MenuScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Initializer
    
    init(mainScreenViewController: UIViewController, categoriesScreenViewController: UIViewController, label3ScreenViewController: UIViewController) {
        self.mainScreenViewController = mainScreenViewController
        self.categoriesScreenViewController = categoriesScreenViewController
        self.label3ScreenViewController = label3ScreenViewController
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
    let label3ScreenViewController: UIViewController
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "MenuScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuScreenView.mainTabBarItem.addTarget(self, action: #selector(main), for: .touchUpInside)
        menuScreenView.categoriesTabBarItem.addTarget(self, action: #selector(categories), for: .touchUpInside)
        menuScreenView.label3TabBarItem.addTarget(self, action: #selector(label3), for: .touchUpInside)
        main()
        setContent()
    }
    
    @objc private func main() {
        screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        screenController?.removeFromParent()
        addChild(mainScreenViewController)
        menuScreenView.setHomeScreenView(mainScreenViewController.view)
        mainScreenViewController.didMove(toParent: self)
        screenController = mainScreenViewController
    }
    
    @objc private func categories() {
        self.screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(categoriesScreenViewController)
        menuScreenView.setCreateScreenView(categoriesScreenViewController.view)
        categoriesScreenViewController.didMove(toParent: self)
        screenController = categoriesScreenViewController
    }
    
    @objc private func label3() {
        self.screenController?.willMove(toParent: nil)
        menuScreenView.setScreenView(nil)
        self.screenController?.removeFromParent()
        addChild(label3ScreenViewController)
        menuScreenView.setSearchScreenView(label3ScreenViewController.view)
        label3ScreenViewController.didMove(toParent: self)
        screenController = label3ScreenViewController
    }
    
    // MARK: Content
    
    private func setContent() {
        menuScreenView.mainTabBarItem.textLabel.text = localizer.localizeText("main")
        menuScreenView.categoriesTabBarItem.textLabel.text = localizer.localizeText("categories")
        menuScreenView.label3TabBarItem.textLabel.text = localizer.localizeText("label3")
    }
    
}
