//
//  PeriodSegmentedControlBaseView.swift
//
//
//  Created by SONG on 4/10/24.
//

import UIKit.UIView

import ToDoGardenUIResource

final class PeriodSegmentedControlBaseView: UIImageView {
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  convenience init(with items: [String]) {
    self.init()
    self.setup(with: items)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

//MARK: - private functions
extension PeriodSegmentedControlBaseView {
  private func setup(with items: [String]) {
    self.setupBackgroundView()
  }
  
  private func setupBackgroundView() {
    self.image = UIImage.periodSegmentedControlBackground
    self.isUserInteractionEnabled = true
    self.contentMode = ContentMode.scaleToFill
  }
}
