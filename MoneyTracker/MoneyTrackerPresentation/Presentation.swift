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
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        window.rootViewController = viewController
    }
    
}
