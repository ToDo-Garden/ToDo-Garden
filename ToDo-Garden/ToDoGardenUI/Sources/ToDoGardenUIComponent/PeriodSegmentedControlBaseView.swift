//
//  PeriodSegmentedControlBaseView.swift
//
//
//  Created by SONG on 4/10/24.
//

import UIKit.UIView

final class PeriodSegmentedControlBaseView: UIImageView {
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  convenience init(with items: [String]) {
    self.init()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

//MARK: - private functions
extension PeriodSegmentedControlBaseView {
}
