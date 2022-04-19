//
//  TraitCollectionChangeNotifyWindow.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 19.04.2022.
//

import UIKit

class TraitCollectionChangeNotifyWindow: UIWindow {
    
    var didChangeUserInterfaceStyleClosure: ((UIUserInterfaceStyle) -> Void)?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        if traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle {
            didChangeUserInterfaceStyleClosure?(traitCollection.userInterfaceStyle)
        }
    }
}
