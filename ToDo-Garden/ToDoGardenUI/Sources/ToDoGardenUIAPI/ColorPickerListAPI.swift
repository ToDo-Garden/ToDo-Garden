//
//  ColorPickerListAPI.swift
//
//
//  Created by SONG on 7/15/24.
//

import Combine
import UIKit.UIColor

public protocol ColorPickerListAPI: UIView {
  var colors: [UIColor] { get }
  var selected: CurrentValueSubject<Int?, Never> { get }
}
