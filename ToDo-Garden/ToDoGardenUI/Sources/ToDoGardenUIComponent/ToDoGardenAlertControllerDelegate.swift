//
//  ToDoGardenAlertControllerDelegate.swift
//
//
//  Created by SONG on 5/4/24.
//

import Foundation

import ToDoGardenUIConstant

public protocol ToDoGardenAlertControllerDelegate: AnyObject {
  func handleButtonAction(_ buttonType: Constant.ToDoGardenAlertView.Content.ButtonActionType)
}
