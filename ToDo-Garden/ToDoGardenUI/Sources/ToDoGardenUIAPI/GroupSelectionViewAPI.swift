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
