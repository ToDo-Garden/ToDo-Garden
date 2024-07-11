//
//  RepeatOtherDaysViewAPI.swift
//
//
//  Created by Wood on 7/11/24.
//

import Foundation

public protocol RepeatOtherDaysViewAPI: ToDoRepeatSelectionViewAPI {
  func updateDate(startDate: String, endDate: String)
  func updateDateButtonState(isSelected: Bool)
  func updateRepeatEverydayButton(isSelected: Bool)
}
