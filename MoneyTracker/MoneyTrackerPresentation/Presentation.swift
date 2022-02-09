//
//  Presentation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit

public protocol PresentationDelegate: AnyObject {
    func presentationCategories(_ presentation: Presentation) -> [Category]
    func presentation(_ presentation: Presentation, addCategory addingCategory: AddingCategory)
    func presentation(_ presentation: Presentation, deleteCategory category: Category)
    func presentation(_ presentation: Presentation, sortCategories categories: [Category])
    func presentation(_ presentation: Presentation, editCategory editingCategory: Category)
}

public final class Presentation: AUIWindowPresentation {
    
    // MARK: Delegate
    
    public weak var delegate: PresentationDelegate!
    
    // MARK: Display
    
    public func display() {
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .green
        let mainNavigationController = AUINavigationBarHiddenNavigationController()
        mainNavigationController.viewControllers = [mainViewController]
        let categoriesViewController = UIViewController()
        categoriesViewController.view.backgroundColor = .yellow
        let categoriesNavigationController = AUINavigationBarHiddenNavigationController()
        categoriesNavigationController.viewControllers = [categoriesViewController]
        let settingsViewController = createSettingsScreenViewController()
        let settingsNavigationController = AUINavigationBarHiddenNavigationController()
        settingsNavigationController.viewControllers = [settingsViewController]
        let menuViewController = MenuScreenViewController(mainScreenViewController: mainNavigationController, categoriesScreenViewController: categoriesNavigationController, settingsScreenViewController: settingsNavigationController)
        menuViewController.label3()
        let menuNavigationController = AUINavigationBarHiddenNavigationController()
        menuNavigationController.viewControllers = [menuViewController]
        self.menuNavigationController = menuNavigationController
        self.menuScreenViewController = menuViewController
        self.mainViewController = mainViewController
        self.mainNavigationController = mainNavigationController
        self.categoriesNavigationController = categoriesNavigationController
        self.settingsScreenViewController = settingsViewController
        self.settingsNavigationController = settingsNavigationController
        window.rootViewController = menuNavigationController
    }
    
    // MARK: Menu Navigation Controller
    
    private var menuNavigationController: UINavigationController?
    
    // MARK: Menu View Controller
    
    private var menuScreenViewController: MenuScreenViewController?
    
    // MARK: Main Navigation Controller
    
    private var mainNavigationController: UINavigationController?
    
    // MARK: Main View Controller
    
    private var mainViewController: UIViewController?
    
    // MARK: Categories Navigation Controller
    
    private var categoriesNavigationController: UINavigationController?
    
    // MARK: Categories View Controller
    
    private var categoriesViewController: CategoriesScreenViewController?
    
    private func createCategoriesViewController() -> CategoriesScreenViewController {
        let categories = delegate.presentationCategories(self)
        let viewController = CategoriesScreenViewController(categories: categories)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        viewController.didSelectAddCategoryClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createAddCategoryScreenViewController()
            self.addCategoryViewController = viewController
            self.menuNavigationController?.present(viewController, animated: true, completion: nil)
        }
        viewController.didDeleteCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            self.delegate.presentation(self, deleteCategory: category)
        }
        viewController.didSortCategoriesClosure = { [weak self] categories in
            guard let self = self else { return }
            self.delegate.presentation(self, sortCategories: categories)
        }
        viewController.didSelectCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            let viewController = self.createEditCategoryScreenViewController(category: category)
            self.editCategoryViewController = viewController
            self.menuNavigationController?.present(viewController, animated: true, completion: nil)
        }
        return viewController
    }
    
    // MARK: Settings Navigation Controller
    
    private var settingsNavigationController: UINavigationController?
    
    // MARK: Add Category View Controller
    
    private var addCategoryViewController: AddCategoryScreenViewController?
        
    private func createAddCategoryScreenViewController() -> AddCategoryScreenViewController {
        let viewController = AddCategoryScreenViewController()
        viewController.addCategoryClosure = { [weak self] addingCategory in
            guard let self = self else { return }
            self.delegate.presentation(self, addCategory: addingCategory)
            let categories = self.delegate.presentationCategories(self)
            self.categoriesViewController?.updateCategories(categories)
            viewController.dismiss(animated: true, completion: nil)
        }
        return viewController
    }
    
    // MARK: Add Category View Controller
    
    private var editCategoryViewController: EditCategoryScreenViewController?
        
    private func createEditCategoryScreenViewController(category: Category) -> EditCategoryScreenViewController {
        let viewController = EditCategoryScreenViewController(category: category)
        viewController.editCategoryClosure = { [weak self] category in
            guard let self = self else { return }
            self.delegate.presentation(self, editCategory: category)
            let categories = self.delegate.presentationCategories(self)
            self.categoriesViewController?.updateCategories(categories)
            viewController.dismiss(animated: true, completion: nil)
        }
        return viewController
    }
    
    // MARK: Settings Screen View Controller
    
    private var settingsScreenViewController: SettingsScreenViewController?
    
    private func createSettingsScreenViewController() -> SettingsScreenViewController {
        let viewController = SettingsScreenViewController()
        viewController.didSelectCategoriesClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createCategoriesViewController()
            self.categoriesViewController = viewController
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        viewController.didSelectAccountsClosure = { [weak self] in
            guard let self = self else { return }
            let viewController = self.createAccountsViewController()
            self.accoutViewController = viewController
            self.menuNavigationController?.pushViewController(viewController, animated: true)
        }
        return viewController
    }
    
    // MARK: Accounts Scree View Controller
    
    private var accoutViewController: AccountsScreenViewController?
    
    private func createAccountsViewController() -> AccountsScreenViewController {
        let accounts: [Any] = [NSObject(), NSObject(), NSObject()]
        let viewController = AccountsScreenViewController(accounts: accounts)
        viewController.backClosure = { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController?.popViewController(animated: true)
        }
        
        return viewController
    }
    
}
