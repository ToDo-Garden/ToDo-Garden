//
//  DateRangePresentDelegate.swift
//  ToDoGardenUI
//
//  Created by SONG on 1/31/25.
//

import Foundation

protocol DateRangePresentDelegate: AnyObject {
  func didTouchCell(startDate: Date?, endDate: Date?)
}
