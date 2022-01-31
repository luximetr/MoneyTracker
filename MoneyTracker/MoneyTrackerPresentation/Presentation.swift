//
//  Presentation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit

public class Presentation: AUIWindowPresentation {
    
    public func display() {
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .green
        let mainNavigationController = AUINavigationBarHiddenNavigationController()
        mainNavigationController.viewControllers = [mainViewController]
        let categoriesViewController = CategoriesScreenViewController()
        let categoriesNavigationController = AUINavigationBarHiddenNavigationController()
        categoriesNavigationController.viewControllers = [categoriesViewController]
        let label3ViewController = UIViewController()
        label3ViewController.view.backgroundColor = .yellow
        let label3NavigationController = AUINavigationBarHiddenNavigationController()
        label3NavigationController.viewControllers = [label3ViewController]
        let menuViewController = MenuScreenViewController(mainScreenViewController: mainNavigationController, categoriesScreenViewController: categoriesNavigationController, label3ScreenViewController: label3NavigationController)
        let menuNavigationController = AUINavigationBarHiddenNavigationController()
        menuNavigationController.viewControllers = [menuViewController]
        self.menuNavigationController = menuNavigationController
        self.menuViewController = menuViewController
        self.mainViewController = mainViewController
        self.mainNavigationController = mainNavigationController
        self.categoriesViewController = categoriesViewController
        self.categoriesNavigationController = categoriesNavigationController
        self.label3ViewController = label3ViewController
        self.label3NavigationController = label3NavigationController
        window.rootViewController = menuNavigationController
    }
    
    // MARK: Menu Navigation Controller
    
    private var menuNavigationController: UINavigationController?
    
    // MARK: Menu View Controller
    
    private var menuViewController: MenuScreenViewController?
    
    // MARK: Main Navigation Controller
    
    private var mainNavigationController: UINavigationController?
    
    // MARK: Main View Controller
    
    private var mainViewController: UIViewController?
    
    // MARK: Categories Navigation Controller
    
    private var categoriesNavigationController: UINavigationController?
    
    // MARK: Categories View Controller
    
    private var categoriesViewController: CategoriesScreenViewController?
    
    // MARK: Label3 Navigation Controller
    
    private var label3NavigationController: UINavigationController?
    
    // MARK: Label3 View Controller
    
    private var label3ViewController: UIViewController?
    
}
