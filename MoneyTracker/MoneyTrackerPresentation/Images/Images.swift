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

    static var card: UIImage { return UIImage(systemName: "creditcard.fill") ?? UIImage() }
    static var tag: UIImage { return UIImage(systemName: "tag.fill") ?? UIImage() }
    static var star: UIImage { return UIImage(systemName: "star.fill") ?? UIImage() }
    static var plusInDashCircle: UIImage { return _UIImage(named: "plusInDashCircle") }
    
}
