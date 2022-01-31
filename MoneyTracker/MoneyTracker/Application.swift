//
//  Application.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import UIKit
import AUIKit
import MoneyTrackerPresentation
typealias Presentation = MoneyTrackerPresentation.Presentation

class Application: AUIEmptyApplication {
    
    // MARK: Events
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        displayPresentation()
    }
    
    // MARK: Presentation
    
    private lazy var presentationWindow: UIWindow = {
        let window = self.window ?? UIWindow()
        window.makeKeyAndVisible()
        return window
    }()
    
    private lazy var presentation: Presentation = {
        let presentation = Presentation(window: presentationWindow)
        return presentation
    }()
    
    private func displayPresentation() {
        presentation.display()
    }
    
}
