//
//  TextInputViewAPI.swift
//
//
//  Created by SONG on 7/10/24.
//

import UIKit.UIColor

public protocol TextInputViewAPI {
  func setBeginEditing(with text: String)
  func changeBottomLine(color: UIColor)
}
