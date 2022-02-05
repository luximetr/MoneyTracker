//
//  Images.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.01.2022.
//

import Foundation
import UIKit

private class Class {}
private let bundle = Bundle(for: Class.self)

private func _UIImage(named: String) -> UIImage {
    return UIImage(named: named, in: bundle, compatibleWith: nil) ?? UIImage()
}

enum Images {

    static var card: UIImage { return _UIImage(named: "card") }
    static var tag: UIImage { return _UIImage(named: "tag") }
    static var gear: UIImage { return _UIImage(named: "gear") }
    static var plusInDashCircle: UIImage { return _UIImage(named: "plusInDashCircle") }
    
}
