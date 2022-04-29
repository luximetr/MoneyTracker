//
//  ErrorSnackbarViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 29.04.2022.
//

import AUIKit

class ErrorSnackbarViewController: AUIEmptyViewController {
    
    // MARK: - Data
    
    private var appearance: Appearance
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.appearance = appearance
        super.init()
    }
}
