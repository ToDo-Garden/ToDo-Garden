//
//  RepeatOtherDaysViewModel.swift
//
//
//  Created by SONG on 5/28/24.
//

import Foundation

import ToDoGardenUIConstant

public final class RepeatOtherDaysViewModel {
  
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
