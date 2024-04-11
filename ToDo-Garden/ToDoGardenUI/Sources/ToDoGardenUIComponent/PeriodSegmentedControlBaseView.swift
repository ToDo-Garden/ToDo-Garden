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
  var itemsStackView: UIStackView
  
  private var indicatorViewCurrentX: CGFloat = {
    let initialPosition = (
      Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition +
      Constant.PeriodSegmentedControl.Layout.itemWidth
    )
    return initialPosition
  }()
  
  init() {
    self.indicatorView = UIImageView(image: UIImage.periodSegmentedControlIndicator)
    self.itemsStackView = UIStackView()
    super.init(frame: CGRect.zero)
  }
  
  convenience init(with items: [String]) {
    self.init()
    self.setup(with: items)
  }
  
  required init?(coder: NSCoder) {
    self.indicatorView = UIImageView(image: UIImage.periodSegmentedControlIndicator)
    self.itemsStackView = UIStackView()
    super.init(coder: coder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.indicatorView.center.x = self.indicatorViewCurrentX
  }
  
  func moveIndicatorView(to x: CGFloat) {
    self.indicatorViewCurrentX = x
    self.indicatorView.center.x = self.indicatorViewCurrentX
  }
}

//MARK: - private functions
extension PeriodSegmentedControlBaseView {
  private func setup(with items: [String]) {
    self.setupBackgroundView()
    self.setupIndicatorView()
    self.setupStackView()
    self.setupLabels(with: items)
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
  
  private func setupStackView() {
    let padding = Constant.PeriodSegmentedControl.Layout.innerPadding
    
    self.itemsStackView.axis = NSLayoutConstraint.Axis.horizontal
    self.itemsStackView.distribution = UIStackView.Distribution.fillEqually
    self.addSubview(self.itemsStackView)
    
    self.itemsStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        self.itemsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
        self.itemsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
        self.itemsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ]
    )
  }
  
  private func setupLabels(with items: [String]) {
    let segmentWidth = Constant.PeriodSegmentedControl.Layout.itemWidth
    
    for item in items {
      let label = UILabel()
      label.frame.size.width = segmentWidth
      
      let attributedTitle = NSAttributedString(
        string: item,
        attributes: [
          NSAttributedString.Key.font: UIFont.pretendardBodyMedium,
          NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
        ]
      )
      label.attributedText = attributedTitle
      label.textAlignment = NSTextAlignment.center
      self.itemsStackView.addArrangedSubview(label)
    }
  }
}
