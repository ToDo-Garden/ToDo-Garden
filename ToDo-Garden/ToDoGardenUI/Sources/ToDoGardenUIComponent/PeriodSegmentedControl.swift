//
//  PeriodSegmentedControl.swift
//
//
//  Created by SONG on 4/12/24.
//

import UIKit.UIControl

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class PeriodSegmentedControl: UIControl {
  private let periodSegmentedControlAppearance: PeriodSegmentedControlAppearance
  private let items: [String]
  
  public init(items: [String] = Constant.PeriodSegmentedControl.Content.defaultItems) {
    self.items = items
    self.periodSegmentedControlAppearance = PeriodSegmentedControlAppearance(with: self.items)
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  required init?(coder: NSCoder) {
    self.items = Constant.PeriodSegmentedControl.Content.defaultItems
    self.periodSegmentedControlAppearance = PeriodSegmentedControlAppearance(with: self.items)
    super.init(coder: coder)
    self.setup()
  }
}

//MARK: - private functions
extension PeriodSegmentedControl {
  private func setup() {
    self.setupAppearance()
  }
  
  private func setupAppearance() {
    let appearance = self.periodSegmentedControlAppearance.getAssembledView()
    self.addSubview(appearance)
    
    appearance.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        appearance.widthAnchor.constraint(equalTo: self.widthAnchor),
        appearance.heightAnchor.constraint(equalTo: self.heightAnchor),
        appearance.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        appearance.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ]
    )
  }
}
