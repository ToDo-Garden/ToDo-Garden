//
//  PeriodSegmentedControlBaseView.swift
//
//
//  Created by SONG on 4/10/24.
//

import UIKit.UIView

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class PeriodSegmentedControlBaseView: UIImageView {
  var indicatorView: UIImageView
  
  init() {
    self.indicatorView = UIImageView(image: UIImage.periodSegmentedControlIndicator)
    super.init(frame: CGRect.zero)
  }
  
  convenience init(with items: [String]) {
    self.init()
    self.setup(with: items)
  }
  
  required init?(coder: NSCoder) {
    self.indicatorView = UIImageView(image: UIImage.periodSegmentedControlIndicator)
    super.init(coder: coder)
  }
}

//MARK: - private functions
extension PeriodSegmentedControlBaseView {
  private func setup(with items: [String]) {
    self.setupBackgroundView()
    self.setupIndicatorView()
  }
  
  private func setupBackgroundView() {
    self.image = UIImage.periodSegmentedControlBackground
    self.isUserInteractionEnabled = true
    self.contentMode = ContentMode.scaleToFill
  }
  
  private func setupIndicatorView() {
    let indicatorViewWidth = Constant.PeriodSegmentedControl.Layout.indicatorViewWidth
    self.addSubview(self.indicatorView)
    
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        self.indicatorView.widthAnchor.constraint(equalToConstant: indicatorViewWidth),
        self.indicatorView.heightAnchor.constraint(equalToConstant: indicatorViewWidth),
        self.indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ]
    )
  }
}
