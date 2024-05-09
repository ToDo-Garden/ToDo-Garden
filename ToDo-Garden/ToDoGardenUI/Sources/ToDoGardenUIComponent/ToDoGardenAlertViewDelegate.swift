//
//  ToDoGardenAlertViewDelegate.swift
//
//
//  Created by SONG on 5/4/24.
//

import Foundation

protocol ToDoGardenAlertViewDelegate: AnyObject {
  func didTapCancel()
  func didTapKeepConcentration()
  func didTapGoHome()
  func didTapDelete()
  func didTapUnsubscribe()
  func didTapLogout()
  func didTapStopConcentration()
}
