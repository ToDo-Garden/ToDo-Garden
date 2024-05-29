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
