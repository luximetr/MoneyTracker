//
//  PassthroughView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 04.05.2022.
//

import UIKit

class PassthroughView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
}
