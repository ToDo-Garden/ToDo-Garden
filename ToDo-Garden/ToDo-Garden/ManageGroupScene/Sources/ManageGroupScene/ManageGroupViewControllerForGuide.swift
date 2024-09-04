//
//  ManageGroupViewControllerForUsageGuide.swift
//
//
//  Created by SONG on 8/24/24.
//

import UIKit

import ToDoGardenUIComponent

public final class ManageGroupViewControllerForGuide: ManageGroupViewController {
  
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
  }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = ManageGroupViewControllerForGuide()
  
  // 실험용 dimmedView 추가
  let dimmedView = UIView(frame: viewController.view.bounds)
  dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
  viewController.view.addSubview(dimmedView)
  
}
#endif
