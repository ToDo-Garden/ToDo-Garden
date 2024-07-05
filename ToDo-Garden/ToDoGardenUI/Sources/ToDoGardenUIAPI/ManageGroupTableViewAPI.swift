//
//  ManageGroupTableViewAPI.swift
//  
//
//  Created by SONG on 6/21/24.
//

import Foundation

public protocol ManageGroupTableViewAPI {
  func setEditingMode(_ editing: Bool, animated: Bool)
  func reloadData()
}
