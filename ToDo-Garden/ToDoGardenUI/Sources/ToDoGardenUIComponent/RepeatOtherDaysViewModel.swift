//
//  RepeatOtherDaysViewModel.swift
//
//
//  Created by SONG on 5/28/24.
//

import Foundation

import TDUtility
import ToDoGardenUIConstant

final class RepeatOtherDaysViewModel {
  private(set) var dateButton: DateButtonState
  private(set) var divider: DividerState
  private(set) var innerStackView: InnerStackViewState
  private(set) var title: TitleState
  
  private(set) var isSelected: ObservingValue<Bool>
  private(set) var height: ObservingValue<CGFloat>
  
  init(
    startDate: String?,
    endDate: String?
  ) {
    let today = RepeatOtherDaysViewModel.currentDateString()
    self.dateButton = RepeatOtherDaysViewModel.initializeDateButton(
      startDate: startDate,
      endDate: endDate,
      today: today
    )
    
    self.isSelected = ObservingValue(false)
    self.divider = DividerState(isHidden: ObservingValue(true))
    self.innerStackView = InnerStackViewState(
      isHidden: ObservingValue(true),
      height: ObservingValue(Constant.RepeatOtherDaysView.Layout.InnerStackView.height)
    )
    self.height = ObservingValue(Constant.RepeatOtherDaysView.Layout.heightUnselected)
    self.title = TitleState(
      topMargin: ObservingValue(Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel.topMargin)
    )
  }
  
  func toggleSelection() {
    self.updateState()
  }

  func dateButtonSetValueChanged(isSelected: Bool) {
    self.dateButton.isSelected.value = isSelected
  }
  
  func updateDate(startDate: String, endDate: String) {
    self.dateButton.startDate.value = startDate
    self.dateButton.endDate.value = endDate
  }
}

extension RepeatOtherDaysViewModel {
  private func updateState() {
    let constants = Constant.RepeatOtherDaysView.Layout.self
    
    if self.isSelected.value {
      self.divider.isHidden.value = false
      self.innerStackView.isHidden.value = false
      self.dateButton.isSelected.value = true
      self.height.value = constants.heightSelected
      self.title.topMargin.value = constants.Title.topMargin
    } else {
      self.divider.isHidden.value = true
      self.innerStackView.isHidden.value = true
      self.dateButton.isSelected.value = false
      self.height.value = constants.heightUnselected
      self.title.topMargin.value =  Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel.topMargin
    }
    self.innerStackView.height.value = constants.InnerStackView.height
  }
}

extension RepeatOtherDaysViewModel {
  private static func currentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constant.RepeatOtherDaysView.StringLiteral.dateFormat
    return dateFormatter.string(from: Date())
  }
  
  private static func initializeDateButton(startDate: String?, endDate: String?, today: String) -> DateButtonState {
    let isDateUndecided = (startDate == nil) || (endDate == nil)
    return DateButtonState(
      startDate: ObservingValue(startDate ?? today),
      endDate: ObservingValue(endDate ?? today),
      isSelected: ObservingValue(!isDateUndecided)
    )
  }
}

extension RepeatOtherDaysViewModel {
  struct DateButtonState {
    var startDate: ObservingValue<String>
    var endDate: ObservingValue<String>
    var isSelected: ObservingValue<Bool>
  }
  
  struct RingToggleButtonState {
    var isSelected: ObservingValue<Bool>
  }
  
  struct DividerState {
    var isHidden: ObservingValue<Bool>
  }
  
  struct InnerStackViewState {
    var isHidden: ObservingValue<Bool>
    var height: ObservingValue<CGFloat>
  }
  
  struct TitleState {
    var topMargin: ObservingValue<CGFloat>
  }
}
