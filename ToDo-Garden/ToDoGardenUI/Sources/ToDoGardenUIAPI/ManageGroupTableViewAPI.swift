//
//  ManageGroupTableViewAPI.swift
//  
//
//  Created by SONG on 6/21/24.
//

import UIKit.UITableView

public protocol ManageGroupTableViewAPI: UITableView {
  func setEditingMode(_ editing: Bool, animated: Bool)
}
