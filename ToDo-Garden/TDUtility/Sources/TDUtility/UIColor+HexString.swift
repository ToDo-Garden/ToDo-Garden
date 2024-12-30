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
  
  func fromHex(_ hex: String) throws -> UIColor {
    let red, green, blue: CGFloat
    
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])
      
      if hexColor.count == 6 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
          red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
          green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
          blue = CGFloat(hexNumber & 0x0000ff) / 255
          
          return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
      }
    }
    throw NSError(domain: "Converting Error (HexString -> UIColor)", code: 0)
  }
}
