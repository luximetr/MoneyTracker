//
//  UIColorHexConvertor.swift
//  MoneyTrackerUIKit
//
//  Created by Job Ihor Myroniuk on 12.04.2022.
//

import UIKit

open class UIColorHexConvertor {
    
    public init() {
        
    }
    
    open func convertToHexString(color: UIColor) throws -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
        return hexString
    }
    
    open func convertToUIColor(hexString: String) throws -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        
        let alpha: CGFloat = 1.0
        guard let red = colorComponentFrom(colorString: colorString, start: 0, length: 2) else { throw ConvertError.noRedComponentFound }
        guard let green = colorComponentFrom(colorString: colorString, start: 2, length: 2) else { throw ConvertError.noGreenComponentFound }
        guard let blue = colorComponentFrom(colorString: colorString, start: 4, length: 2) else { throw ConvertError.noBlueComponentFound }
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    private func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat? {
        guard start + length <= colorString.count else { return nil }
        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else { return nil }
        let hexFloat = CGFloat(hexComponent)
        let floatValue = CGFloat(hexFloat / 255.0)
        return floatValue
    }
    
    public enum ConvertError: Swift.Error {
        case noRGBComponentsFound
        case noRedComponentFound
        case noGreenComponentFound
        case noBlueComponentFound
    }
}
