//
//  Model+Converting.swift
//  ManageGroupScene
//
//  Created by SONG on 4/3/25.
//

import UIKit

import ManageGroupSceneEntity
import TDFoundation

extension ManageGroup.ToDoGroup {
  func toMyGroup() -> MyGroup {
    return MyGroup(
      groupId: self.groupID.uuidString.lowercased(),
      date: Date.now.description.toYYYYMMDDStringFromISO8601Space(),
      name: self.groupName,
      color: self.progressColor.hexStringFromColor()
    )
  }
}

extension MyGroup {
  func toToDoGroup() -> ManageGroup.ToDoGroup? {
    guard let uuid = UUID(uuidString: groupId.lowercased()) else { return nil }
    
    do {
      let progressColor = try UIColor().fromHex(self.color)
      return ManageGroup.ToDoGroup(
        groupID: uuid,
        groupName: name,
        progressColor: progressColor,
        progressRate: 1.0
      )
    } catch { return nil }
  }
}
