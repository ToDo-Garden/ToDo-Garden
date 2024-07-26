//
//  TextInputViewAPI.swift
//
//
//  Created by SONG on 7/10/24.
//

import UIKit.UIColor

public protocol TextInputViewAPI: UIView {
  var delegate: TextInputViewDelegate? { get set }
  func setBeginEditing(with text: String)
  func changeBottomLine(color: UIColor)
  func getEditingText() -> String?
}

public protocol TextInputViewDelegate: AnyObject {
  func textInputViewDidChange()
}
