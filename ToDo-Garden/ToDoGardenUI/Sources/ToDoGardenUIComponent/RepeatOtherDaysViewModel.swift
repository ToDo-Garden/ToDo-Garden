//
//  RepeatOtherDaysViewModel.swift
//
//
//  Created by SONG on 5/28/24.
//

import Foundation

import ToDoGardenUIConstant

final class RepeatOtherDaysViewModel {
  private(set) var dateButton: DateButtonState
  private(set) var ringToggleButton: RingToggleButtonState
  private(set) var divider: DividerState
  private(set) var innerStackView: InnerStackViewState
  private(set) var title: TitleState
  
  private(set) var isSelected: Observable<Bool>
  private(set) var height: Observable<CGFloat>
  
  init(
    startDate: String?,
    endDate: String?
  ) {
    let today = RepeatOtherDaysViewModel.currentDateString()
    
    self.ringToggleButton = RepeatOtherDaysViewModel.initializeRingToggleButton(
      startDate: startDate,
      endDate: endDate
    )
    
    self.dateButton = RepeatOtherDaysViewModel.initializeDateButton(
      startDate: startDate,
      endDate: endDate,
      today: today
    )
    
    self.isSelected = Observable(false)
    self.divider = DividerState(isHidden: Observable(true))
    self.innerStackView = InnerStackViewState(
      isHidden: Observable(true),
      height: Observable(CGFloat.zero)
    )
    self.height = Observable(Constant.RepeatOtherDaysView.Layout.heightUnselected)
    self.title = TitleState(topMargin: Observable(Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel.topMargin))
  }
  
  func toggleSelection() {
    self.updateState()
  }
}

extension RepeatOtherDaysViewModel {
  private func updateState() {
    let constants = Constant.RepeatOtherDaysView.Layout.self
    
    if self.isSelected.value {
      self.divider.isHidden.value = false
      self.innerStackView.isHidden.value = false
      self.height.value = constants.heightSelected
      self.title.topMargin.value = constants.Title.topMargin
      self.innerStackView.height.value = constants.InnerStackView.height
    } else {
      self.divider.isHidden.value = true
      self.innerStackView.isHidden.value = true
      self.height.value = constants.heightUnselected
      self.title.topMargin.value =  Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel.topMargin
      self.innerStackView.height.value = CGFloat.zero
    }
  }
}

extension RepeatOtherDaysViewModel {
  private static func currentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    return dateFormatter.string(from: Date())
  }
  
  private static func initializeRingToggleButton(startDate: String?, endDate: String?) -> RingToggleButtonState {
    let isDateUndecided = (startDate == nil) || (endDate == nil)
    return RingToggleButtonState(isSelected: Observable(isDateUndecided))
  }
  
  private static func initializeDateButton(startDate: String?, endDate: String?, today: String) -> DateButtonState {
    let isDateUndecided = (startDate == nil) || (endDate == nil)
    return DateButtonState(
      startDate: Observable(startDate ?? today),
      endDate: Observable(endDate ?? today),
      isSelected: Observable(!isDateUndecided)
    )
  }
}

extension RepeatOtherDaysViewModel {
  struct DateButtonState {
    var startDate: Observable<String>
    var endDate: Observable<String>
    var isSelected: Observable<Bool>
  }
  
  struct RingToggleButtonState {
    var isSelected: Observable<Bool>
  }
  
  struct DividerState {
    var isHidden: Observable<Bool>
  }
  
  struct InnerStackViewState {
    var isHidden: Observable<Bool>
    var height: Observable<CGFloat>
  }
  
  struct TitleState {
    var topMargin: Observable<CGFloat>
  }
}

class Observable<T> {
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  private var listener: ((T) -> Void)?
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(_ listener: @escaping (T) -> Void) {
    self.listener = listener
    listener(value)
  }
}
