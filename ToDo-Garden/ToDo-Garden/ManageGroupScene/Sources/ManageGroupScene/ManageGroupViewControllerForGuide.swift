//
//  ManageGroupViewControllerForUsageGuide.swift
//
//
//  Created by SONG on 8/24/24.
//

import UIKit

import ToDoGardenUIComponent

public final class ManageGroupViewControllerForGuide: ManageGroupViewController {
  
  public lazy var groupCells: [UITableViewCell] = {
    self.groupListTableView.layoutIfNeeded()
    let cells = self.groupListTableView.visibleCells
    return cells
  }()
  
  public override init() {
    super.init()
  }

  public override func viewDidLoad() {
    self.view.backgroundColor = UIColor.white
    self.setupTableView()
    self.setupNavigationBar()
    self.fetchGroupList()
  }
  
  override func fetchGroupList() {
    let fetchedData = ManageGroupMockData.guideSceneData
    self.manageGroupTableViewDelegate?.displayedGroups = fetchedData
    self.groupListTableView.reloadData()
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = ManageGroupViewControllerForGuide()
  viewController.loadViewIfNeeded()
  viewController.footerView.backgroundColor = .red
  viewController.groupCells.forEach { cell in
    cell.backgroundColor = .green
  }
  
  let naviController = UINavigationController(rootViewController: viewController)
  return naviController
}
#endif
