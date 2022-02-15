//
//  TemplatesScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit

final class TemplatesScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    private var templates: [ExpenseTemplate]
    
    // MARK: - Life cycle
    
    init(templates: [ExpenseTemplate]) {
        self.templates = templates
    }
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    var addTemplateClosure: (() -> Void)?
    var didSelectTemplateClosure: (() -> Void)?
    var deleteTemplateClosure: (() -> Void)?
    var orderTemplateClosure: (([ExpenseTemplate]) -> Void)?
    
    
}
