//
//  PostGroupColorPickerRowAPI.swift
//  
//
//  Created by SONG on 7/11/24.
//

import UIKit.UIColor

public protocol PostGroupColorPickerRowAPI {
  func getColor() -> UIColor?
  func updateColor(with color: UIColor)
}
