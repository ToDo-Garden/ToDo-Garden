//
//  GroupSelectionViewAPI.swift
//
//
//  Created by Wood on 7/17/24.
//

import UIKit

public protocol GroupSelectionViewItemAPI: Hashable, Comparable {
  var groupId: Int { get }
  var groupName: String { get }
  var groupColor: UIColor { get }
}

public protocol GroupSelectionViewAPI: UIView {
  var delegate: GroupSelectionViewDelegate? { get set }

  func updateGroup(
    current: any GroupSelectionViewItemAPI,
    editableList: [any GroupSelectionViewItemAPI]
  )
  func getCurrentGroupId() -> Int?
}
