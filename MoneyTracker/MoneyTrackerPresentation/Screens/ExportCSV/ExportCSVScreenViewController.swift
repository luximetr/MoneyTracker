//
//  ExportCSVScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 22.04.2022.
//

import UIKit

class ExportCSVScreenViewController: UIActivityViewController {
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    
    // MARK: - Initializer
    
    init(appearance: Appearance, activityItems: [Any]) {
        self.appearance = appearance
        super.init(activityItems: activityItems, applicationActivities: nil)
        overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
    }
}
