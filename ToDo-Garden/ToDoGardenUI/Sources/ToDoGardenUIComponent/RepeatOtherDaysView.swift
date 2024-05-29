//
//  RepeatOtherDaysView.swift
//  
//
//  Created by SONG on 5/28/24.
//

import UIKit

import ToDoGardenUIConstant

public final class RepeatOtherDaysView: ToDoRepeatSelectionView {
  public let ringToggleButton: UIButton
  public let dateButtonSet: DateButtonSet
  private let divider: UIView
  private let innerStackView: UIStackView
  
  private var heightConstraints: [NSLayoutConstraint]
  private var viewModel: RepeatOtherDaysViewModel
  
  override var isSelected: Bool {
    willSet {
      viewModel.isSelected.value = newValue
    }
  }
  
  public init(startDate: String?, endDate: String?) {
    self.viewModel = RepeatOtherDaysViewModel(startDate: startDate, endDate: endDate)
    self.heightConstraints = []
    self.ringToggleButton = UIButton()
    self.innerStackView = UIStackView()
    self.divider = UIView()
    self.dateButtonSet = DateButtonSet()
    super.init(model: ToDoRepeatSelectionView.Model.anotherDay)
    self.setup()
  }
  
  override public func setSelected() {
    self.viewModel.toggleSelection()
    self.animateAppear()
  }
  
  override public func setDeSelected() {
    super.setDeSelected()
    self.animateDisappear()
  }
}

// MARK: - Private functions
extension RepeatOtherDaysView {
  private func setup() {
  }
}

// MARK: - About animation
extension RepeatOtherDaysView {
  private func animateAppear() {

  }
  
  private func animateDisappear() {

  }
}
