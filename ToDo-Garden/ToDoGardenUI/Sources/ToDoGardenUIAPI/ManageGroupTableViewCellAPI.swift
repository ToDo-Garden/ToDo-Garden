//
//  ManageGroupTableViewCellAPI.swift
//
//
//  Created by SONG on 6/24/24.
//

import UIKit.UIColor

public protocol ManageGroupTableViewCellAPI {
  func startAnimation()
  func enterEditingMode()
  func leaveEditingMode()
  
  func applyModelPrimary(
    id: String,
    groupName: String,
    progressColor: UIColor,
    progressRate: Float,
    isEditing: Bool
  )
  
  func applyModelSecondary(
    id: String,
    groupName: String,
    progressColor: UIColor,
    progressRate: Float
  )
  
  func update(color: UIColor?, progressRate: Float?, groupName: String?)

  func setupRightButtonAction(handler: @escaping (UIColor, String) -> Void)
  
  func setupGroupNameButtonAction(handler: @escaping (String) -> Void)
  
  func getIdentifier() -> String
}
