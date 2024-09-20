//
//  ManageGroupTableViewCellAPI.swift
//
//
//  Created by SONG on 6/24/24.
//

import UIKit

public protocol ManageGroupTableViewCellAPI: UITableViewCell {
  func startAnimation()
  func enterEditingMode()
  func leaveEditingMode()
  
  func applyModelPrimary(
    id: UUID,
    groupName: String,
    progressColor: UIColor,
    progressRate: Float,
    isEditing: Bool
  )
  
  func applyModelSecondary(
    id: UUID,
    groupName: String,
    progressColor: UIColor,
    progressRate: Float
  )
  
  func update(color: UIColor?, progressRate: Float?, groupName: String?)

  func setupRightButtonAction(handler: @escaping (UUID, String, UIColor) -> Void)
  
  func setupGroupNameButtonAction(handler: @escaping (UUID) -> Void)
  
  func getIdentifier() -> String
}
