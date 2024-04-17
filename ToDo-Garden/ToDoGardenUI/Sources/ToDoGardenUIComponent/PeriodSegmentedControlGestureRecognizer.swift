//
//  PeriodSegmentedControlGestureRecognizer.swift
//
//
//  Created by SONG on 4/17/24.
//

import UIKit

final class PeriodSegmentedControlGestureRecognizer {
  private let panRecognizer: UIPanGestureRecognizer
  private let tapRecognizer: UITapGestureRecognizer
  private let longpressRecognizer: UILongPressGestureRecognizer
  
  init(target: UIControl, panAction: Selector?, tapAction: Selector?, longpressAction: Selector?) {
    self.panRecognizer = UIPanGestureRecognizer(target: target, action: panAction)
    self.tapRecognizer = UITapGestureRecognizer(target: target, action: tapAction)
    self.longpressRecognizer = UILongPressGestureRecognizer(target: target, action: longpressAction)
    
  }
}
