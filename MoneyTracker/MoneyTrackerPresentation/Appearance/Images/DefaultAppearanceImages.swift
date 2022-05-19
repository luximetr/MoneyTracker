//
//  DefaultAppearanceImages.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 19.05.2022.
//

import UIKit

private class Class {}
private let bundle = Bundle(for: Class.self)
private func _UIImage(named: String) -> UIImage {
    return UIImage(named: named, in: bundle, compatibleWith: nil) ?? UIImage()
}

struct DefaultAppearanceImages: AppearanceImages {
    
    var card: UIImage { return _UIImage(named: "card") }
    var statistic: UIImage { return _UIImage(named: "statistic") }
    var gear: UIImage { return _UIImage(named: "gear") }
    var forwardArrow: UIImage { return _UIImage(named: "forwardArrow") }
    var backArrow: UIImage { return _UIImage(named: "backArrow") }
    var check: UIImage { return _UIImage(named: "check") }
    var expenseArrow: UIImage { return _UIImage(named: "expenseArrow") }
    var expensesHistory: UIImage { return _UIImage(named: "expensesHistory") }
    var close: UIImage { return _UIImage(named: "close") }
    var cycle: UIImage { return _UIImage(named: "cycle") }
    var calendar: UIImage { return _UIImage(named: "calendar") }
    
}
