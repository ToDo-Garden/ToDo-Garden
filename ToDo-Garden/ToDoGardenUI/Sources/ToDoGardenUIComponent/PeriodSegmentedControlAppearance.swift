//
//  PeriodSegmentedControlBaseView.swift
//
//
//  Created by SONG on 4/10/24.
//

import UIKit.UIView

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class PeriodSegmentedControlAppearance {
  private let backgroundView: UIImageView
  private let indicatorView: UIImageView
  private let itemsStackView: UIStackView
  
  private var indicatorViewCurrentX: CGFloat
  
  init(with items: [String]) {
    self.backgroundView = UIImageView(image: UIImage.periodSegmentedControlBackground)
    self.indicatorView = UIImageView(image: UIImage.periodSegmentedControlIndicator)
    self.itemsStackView = UIStackView()
    self.indicatorViewCurrentX = Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition +
    Constant.PeriodSegmentedControl.Layout.itemWidth
    self.setup(with: items)
  }
  
  func getAssembledView() -> UIView {
    return self.backgroundView
  }
  
  func moveIndicatorView(to xPosition: CGFloat) {
    self.indicatorViewCurrentX = xPosition
    self.indicatorView.center.x = self.indicatorViewCurrentX
  }
  
  func transformIndicatorViewDownScale() {
    self.indicatorView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
  }
  
  func transformIndicatorViewOriginalScale() {
    self.indicatorView.transform = CGAffineTransform.identity
  }
  
  func getIndicatorViewCenter() -> CGFloat {
    return self.indicatorViewCurrentX
  }
}

// MARK: - private functions

extension PeriodSegmentedControlAppearance {
  private func setup(with items: [String]) {
    self.setupBackgroundView()
    self.setupIndicatorViewLayout()
    self.setupStackView()
    self.setupLabels(with: items)
  }
  
  private func setupBackgroundView() {
    self.backgroundView.isUserInteractionEnabled = true
    self.backgroundView.contentMode = UIView.ContentMode.scaleToFill
  }
  
  private func setupIndicatorViewLayout() {
    let indicatorViewWidth = Constant.PeriodSegmentedControl.Layout.indicatorViewWidth
    self.backgroundView.addSubview(self.indicatorView)
    
    self.indicatorView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.indicatorView.widthAnchor.constraint(equalToConstant: indicatorViewWidth),
        self.indicatorView.heightAnchor.constraint(equalToConstant: indicatorViewWidth),
        self.indicatorView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor)
      ]
    )
  }
  
  private func setupStackView() {
    let padding = Constant.PeriodSegmentedControl.Layout.innerPadding
    
    self.itemsStackView.axis = NSLayoutConstraint.Axis.horizontal
    self.itemsStackView.distribution = UIStackView.Distribution.fillEqually
    self.backgroundView.addSubview(self.itemsStackView)
    
    self.itemsStackView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.itemsStackView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: padding),
        self.itemsStackView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -padding),
        self.itemsStackView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor)
      ]
    )
  }
  
  private func setupLabels(with items: [String]) {
    let segmentWidth = Constant.PeriodSegmentedControl.Layout.itemWidth
    
    for labelTitle in items {
      let label = UILabel()
      label.frame.size.width = segmentWidth
      
      let attributedTitle = NSAttributedString(
        string: labelTitle,
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

// MARK: - for customizing

extension PeriodSegmentedControlAppearance {
  func changeBackgroundImage(_ image: UIImage) {
    self.backgroundView.image = image
  }
  
  func changeIndicatorImage(_ image: UIImage) {
    self.indicatorView.image = image
  }
  
  func changeInitialSelectedItem(index: Int, numberOfItems: Int) {
    guard index < numberOfItems && index >= Int.zero else {
      return
    }
    
    let startPoint = Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition
    let additionalWeight = (
      Constant.PeriodSegmentedControl.Layout.itemWidth *
      CGFloat(index)
    )
    
    self.indicatorViewCurrentX = startPoint + additionalWeight
  }
}
