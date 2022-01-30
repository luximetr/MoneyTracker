//
//  Application.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit

class Application: AUIEmptyApplication {
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        let window = self.window ?? UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }
    
}
