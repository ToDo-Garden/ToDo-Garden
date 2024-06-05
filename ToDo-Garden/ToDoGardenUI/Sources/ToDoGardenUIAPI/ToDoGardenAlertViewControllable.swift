//
//  ToDoGardenAlertViewControllable.swift
//
//
//  Created by SONG on 6/4/24.
//

import ToDoGardenUIConstant

public protocol ToDoGardenAlertViewControllable: ViewControllable {
  var delegate: ToDoGardenAlertControllerDelegate? { get set }
}

public protocol ToDoGardenAlertControllerDelegate: AnyObject {
  func handleButtonAction(_ buttonType: Constant.ToDoGardenAlertView.Content.ButtonActionType)
}
