//
//  UIColor+HexString.swift
//  TDUtility
//
//  Created by SONG on 12/19/24.
//

import UIKit.UIColor

public extension UIColor {
  func hexStringFromColor() -> String {
    let multiplier: CGFloat = 255.0
    let redShift: Int = 16
    let greenShift: Int = 8
    
    var red: CGFloat = CGFloat.zero
    var green: CGFloat = CGFloat.zero
    var blue: CGFloat = CGFloat.zero
    var alpha: CGFloat = CGFloat.zero
    
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let rgb: Int = (Int(red * multiplier) << redShift) |
    (Int(green * multiplier) << greenShift) |
    (Int(blue * multiplier))
    
    return String(format: "#%06x", rgb)
  }
}
