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
typealias PresentationDelegate = MoneyTrackerPresentation.PresentationDelegate
import MoneyTrackerStorage
typealias Storage = MoneyTrackerStorage.Storage

class Application: AUIEmptyApplication, PresentationDelegate {
    
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
        presentation.delegate = self
        return presentation
    }()
    
    private func displayPresentation() {
        presentation.display()
    }
    
    func presentationCategories(presentation: Presentation) -> [PresentationCategory] {
        let storageCategories = (try? storage.categories()) ?? []
        let categories = storageCategories.map({ Category(storageCategoty: $0) })
        let presentationCategories = categories.map({ $0.presentationCategory })
        return presentationCategories
    }
    
    // MARK: Storage
    
    private lazy var storage: Storage = {
        let storage = Storage()
        return storage
    }()
    
}
