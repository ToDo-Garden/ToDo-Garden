//
//  RepeatOtherDaysView.swift
//
//
//  Created by SONG on 5/28/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class RepeatOtherDaysView: ToDoRepeatSelectionView {
  public let ringToggleButton: UIButton
  public let dateButtonSet: DateButtonSet
  private let dividerView: UIView
  private let innerStackView: UIStackView

  private var heightConstraints: [NSLayoutConstraint]
  private var viewModel: RepeatOtherDaysViewModel

  override var isSelected: Bool {
    willSet {
      self.viewModel.isSelected.value = newValue
      self.animateAppearance(isSelected: newValue)
    }
  }

  public init(startDate: String?, endDate: String?) {
    self.viewModel = RepeatOtherDaysViewModel(startDate: startDate, endDate: endDate)
    self.heightConstraints = []
    self.ringToggleButton = UIButton()
    self.innerStackView = UIStackView()
    self.dividerView = UIView()
    self.dateButtonSet = DateButtonSet()
    super.init(model: ToDoRepeatSelectionView.Model.anotherDay)
    self.setup()
  }

  override func updateUI(isSelected: Bool) {
    super.updateUI(isSelected: isSelected)
    self.updateBackgroundColor()
  }
}

extension RepeatOtherDaysView: RepeatOtherDaysViewAPI {
  public func updateDate(startDate: String, endDate: String) {
    self.viewModel.updateDate(startDate: startDate, endDate: endDate)
  }

  public func updateDateButtonState(isSelected: Bool) {
    self.viewModel.dateButton.isSelected.value = isSelected
  }

  public func updateRepeatEverydayButton(isSelected: Bool) {
    self.ringToggleButton.isSelected = isSelected
  }

  public func addActionToRingToggleButton(_ closure: @escaping (Bool) -> Void) {
    let buttonAction = UIAction { _ in
      let isRingToggleButtonSelected = self.ringToggleButton.isSelected
      closure(isRingToggleButtonSelected)
    }

    self.ringToggleButton.addAction(buttonAction, for: UIControl.Event.touchUpInside)
  }
}

// MARK: - Private functions
extension RepeatOtherDaysView {
  private func setup() {
    self.bindViewModel()
    self.usingAutolayout()
    self.setupInitialHeightConstraint()
    self.applyRingToggleButton()
    self.buildStackView()
    self.setupButtonActions()
  }

  private func bindViewModel() {
    self.bindDateButtons()
    self.bindSelectionStates()
    self.bindVisibilityStates()
    self.bindViewHeights()
    self.bindMargins()
  }

  private func setupInitialHeightConstraint() {
    self.heightConstraints =
    [
      self.heightAnchor.constraint(equalToConstant: self.viewModel.height.value),
      self.innerStackView.heightAnchor.constraint(equalToConstant: self.viewModel.innerStackView.height.value)
    ]

    for constraint in heightConstraints {
      constraint.isActive = true
    }
  }

  private func applyRingToggleButton() {
    self.ringToggleButton.applyRingToggleButtonStyle()
  }

  private func setupButtonActions() {
    let ringToggleAction = UIAction { [weak self] _ in
      self?.viewModel.ringToggleButtonTapped()
    }

    let dateButtonAction = UIAction { [weak self] _ in
      guard let isDateButtonSelected = self?.dateButtonSet.isSelected else {
        return
      }

      self?.viewModel.dateButtonSetValueChanged(isSelected: isDateButtonSelected)
    }

    self.ringToggleButton.addAction(ringToggleAction, for: UIControl.Event.touchUpInside)

    self.dateButtonSet.addAction(dateButtonAction, for: UIControl.Event.valueChanged)
  }
}

// MARK: - About Building Views

extension RepeatOtherDaysView {
  private func buildStackView() {
    self.innerStackView.axis = NSLayoutConstraint.Axis.vertical
    self.innerStackView.distribution = .fillProportionally
    self.buildDivider()
    self.buildRows()
    self.innerStackView.isUserInteractionEnabled = true
    self.addSubview(self.innerStackView)
    self.innerStackView.usingAutolayout()

    let constants = Constant.RepeatOtherDaysView.Layout.self

    NSLayoutConstraint.activate(
      [
        self.innerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: constants.CommonMargin.broad),
        self.innerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.innerStackView.widthAnchor.constraint(equalToConstant: constants.InnerStackView.width)
      ]
    )
  }

  private func buildDivider() {
    self.dividerView.backgroundColor = UIColor.toDoGardenGreenGray
    self.dividerView.usingAutolayout()
    self.addSubview(self.dividerView)
    let constants = Constant.RepeatOtherDaysView.Layout.self
    NSLayoutConstraint.activate(
      [
        self.dividerView.widthAnchor.constraint(equalToConstant: constants.Divider.width),
        self.dividerView.heightAnchor.constraint(equalToConstant: constants.Divider.height),
        self.dividerView.topAnchor.constraint(equalTo: self.topAnchor, constant: constants.CommonMargin.broad),
        self.dividerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
    self.innerStackView.addSpacing(constants.CommonMargin.narrow)
  }

  private func buildRows() {
    self.buildToggleRow()
    self.innerStackView.addSpacing(
      Constant.RepeatOtherDaysView.Layout.CommonMargin.broad
    )
    self.buildDateRow()
  }

  private func buildToggleRow() {
    let row = Styled.Row(
      configuration: Styled.Row.Configuration.repeatOtherDays(
        Styled.Row.Configuration.RepeatOtherDaysModel.init(
          title: Constant.RepeatOtherDaysView.StringLiteral.everyday
        )
      ),
      with: [self.ringToggleButton]
    )

    self.innerStackView.addArrangedSubview(row)
  }

  private func buildDateRow() {
    let row = Styled.Row(
      configuration: Styled.Row.Configuration.repeatOtherDays(
        Styled.Row.Configuration.RepeatOtherDaysModel.init(
          title: Constant.RepeatOtherDaysView.StringLiteral.timeSet
        )
      ),
      with: []
    )
    let constants = Constant.RepeatOtherDaysView.Layout.self
    self.innerStackView.insertArrangedSubview(row, at: 2)
    self.innerStackView.addSubview(self.dateButtonSet)
    self.dateButtonSet.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.dateButtonSet.topAnchor.constraint(
          equalTo: row.topAnchor,
          constant: constants.CommonMargin.narrow
        ),
        self.dateButtonSet.trailingAnchor.constraint(
          equalTo: row.trailingAnchor,
          constant: constants.DateButtonSet.trailing
        )
      ]
    )
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
      guard let self else { return }

      self.updateViewModelWhenSelected()
      self.updateUI()
    }

    self.viewModel.ringToggleButton.isSelected.bind { [weak self] isSelected in
      self?.ringToggleButton.isSelected = isSelected
      if isSelected == true {
        self?.viewModel.dateButton.isSelected.value = false
      }
      self?.updateBackgroundColor()
    }

    self.viewModel.dateButton.isSelected.bind { [weak self] isSelected in
      self?.dateButtonSet.isSelected = isSelected
      if isSelected == true {
        self?.viewModel.ringToggleButton.isSelected.value = false
      }
    }
  }

  private func updateViewModelWhenSelected() {
    if self.viewModel.isSelected.value {
      self.viewModel.toggleSelection()
    }
  }

  private func bindVisibilityStates() {
    self.viewModel.divider.isHidden.bind { [weak self] isHidden in
      self?.dividerView.isHidden = isHidden
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

// MARK: - About Updating states
extension RepeatOtherDaysView {
  private func updateUI() {
    self.dividerView.isHidden = self.viewModel.divider.isHidden.value
    self.innerStackView.isHidden = self.viewModel.innerStackView.isHidden.value
    self.updateRepeatOtherDaysViewHeightConstraint(to: self.viewModel.height.value)
    self.updateTitleConstraint(to: self.viewModel.title.topMargin.value)
    self.updateInnerStackViewViewHeightConstraint(to: self.viewModel.innerStackView.height.value)
  }

  private func updateBackgroundColor() {
    if self.viewModel.isSelected.value && self.viewModel.ringToggleButton.isSelected.value {
      self.backgroundColor = UIColor.toDoGardenGreenBackground
    } else {
      self.backgroundColor = UIColor.clear
    }
  }

  private func updateRepeatOtherDaysViewHeightConstraint(to height: CGFloat) {
    if self.heightConstraints.isEmpty {
      return
    }

    guard let repeatOtherDaysViewHeightConstraint = self.heightConstraints.first else {
      return
    }
    repeatOtherDaysViewHeightConstraint.constant = height
  }

  private func updateInnerStackViewViewHeightConstraint(to height: CGFloat) {
    if self.heightConstraints.isEmpty {
      return
    }

    guard let innerStackViewHeightConstraint = self.heightConstraints.last else {
      return
    }

    innerStackViewHeightConstraint.constant = height
  }

  private func updateTitleConstraint(to topMargin: CGFloat) {
    self.repetitionLabelTopAchor.constant = topMargin
  }
}

// MARK: - About animation
extension RepeatOtherDaysView {
  private func animateAppearance(isSelected: Bool) {
    if isSelected {
      self.animateAppear()
    } else {
      self.animateDisappear()
    }
  }

  private func animateAppear() {
    self.animateLayout()
    UIView.animate(withDuration: Constant.RepeatOtherDaysView.AboutAnimation.duration) {
      self.innerStackView.alpha = Constant.RepeatOtherDaysView.AboutAnimation.alphaAppear
      self.dividerView.alpha = Constant.RepeatOtherDaysView.AboutAnimation.alphaAppear
    }
  }

  private func animateDisappear() {
    UIView.animate(withDuration: Constant.RepeatOtherDaysView.AboutAnimation.duration) {
      self.innerStackView.alpha = Constant.RepeatOtherDaysView.AboutAnimation.alphaDisappear
      self.dividerView.alpha = Constant.RepeatOtherDaysView.AboutAnimation.alphaDisappear
    } completion: { _ in
      Task {
        try await Task.sleep(nanoseconds: Constant.RepeatOtherDaysView.AboutAnimation.delay)
        self.viewModel.toggleSelection()
        self.animateLayout()
      }
    }
  }

  private func animateLayout() {
    UIView.animate(
      withDuration: Constant.RepeatOtherDaysView.AboutAnimation.duration
    ) {
      self.superview?.layoutIfNeeded()
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let repeatOtherDaysView = RepeatOtherDaysView(startDate: nil, endDate: nil)

  return repeatOtherDaysView
}
#endif
