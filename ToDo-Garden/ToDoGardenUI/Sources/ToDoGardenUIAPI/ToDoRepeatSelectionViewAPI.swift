//
//  ToDoRepeatSelectionViewAPI.swift
//
//
//  Created by Wood on 7/11/24.
//

import UIKit.UIView

public protocol ToDoRepeatSelectionViewAPI {
  var view: UIView { get }

  func setSelected()
  func setDeSelected()
  func bindTapGesture(sender: @escaping (Bool) -> Void)
}
