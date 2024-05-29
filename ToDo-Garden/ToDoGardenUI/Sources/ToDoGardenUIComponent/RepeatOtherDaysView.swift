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
    self.bindViewModel()
  }
  
  private func bindViewModel() {
    self.bindDateButtons()
    self.bindSelectionStates()
    self.bindVisibilityStates()
    self.bindViewHeights()
    self.bindMargins()
  }
}

// MARK: - About Binding
extension RepeatOtherDaysView {
  private func bindDateButtons() {
    self.viewModel.dateButton.startDate.bind { [weak self] date in
      self?.dateButtonSet.updateStartDateButton(title: date)
    }
    
    self.viewModel.dateButton.endDate.bind { [weak self] date in
      self?.dateButtonSet.updateEndDateButton(title: date)
    }
  }
  
  private func bindSelectionStates() {
    self.viewModel.isSelected.bind { [weak self] _ in
      self?.updateUI()
      self?.updateBackgroundColor()
    }
    
    self.viewModel.ringToggleButton.isSelected.bind { [weak self] isSelected in
      self?.ringToggleButton.isSelected = isSelected
      if isSelected == true {
        self?.dateButtonSet.isSelected = false
      }
      self?.updateBackgroundColor()
    }
    
    self.viewModel.dateButton.isSelected.bind { [weak self] isSelected in
      self?.dateButtonSet.isSelected = isSelected
      if isSelected == true {
        self?.ringToggleButton.isSelected = false
      }
      self?.updateBackgroundColor()
    }
  }
  
  private func bindVisibilityStates() {
    self.viewModel.divider.isHidden.bind { [weak self] isHidden in
      self?.divider.isHidden = isHidden
    }
    
    self.viewModel.innerStackView.isHidden.bind { [weak self] isHidden in
      self?.innerStackView.isHidden = isHidden
    }
  }
  
  private func bindViewHeights() {
    self.viewModel.height.bind { [weak self] height in
      self?.updateRepeatOtherDaysViewHeightConstraint(to: height)
    }
    
    self.viewModel.innerStackView.height.bind { [weak self] height in
      self?.updateInnerStackViewViewHeightConstraint(to: height)
    }
  }
  
  private func bindMargins() {
    self.viewModel.title.topMargin.bind { [weak self] margin in
      self?.updateTitleConstraint(to: margin)
    }
  }
}
  }
}

// MARK: - About animation
extension RepeatOtherDaysView {
  private func animateAppear() {

  }
  
  private func animateDisappear() {

  }
}
