//
//  ManageGroupViewControllerForUsageGuide.swift
//
//
//  Created by SONG on 8/24/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIConstant

public final class ManageGroupViewControllerForGuide: ManageGroupViewController {
  
  public override init() {
    super.init()
  }
  
  public override func viewDidLoad() {
    self.view.backgroundColor = UIColor.white
    self.setupTableView(isForGuide: true)
    self.setupNavigationBar()
    self.fetchGroupList()
    self.setFooterViewForGuide()
    self.view.isUserInteractionEnabled = false
  }
  
  override func fetchGroupList() {
    let fetchedData = ManageGroupMockData.guideSceneData
    self.displayedGroups = fetchedData
    self.manageGroupTableViewDelegate?.displayedGroups = fetchedData
  }
  
  private func setFooterViewForGuide() {
    self.footerView.layer.cornerRadius = Constant.Layout.Cell.cornerRadius
    self.footerView.layer.masksToBounds = true
    self.footerView.usingAutolayout()
    self.view.addSubview(self.footerView)
    
    NSLayoutConstraint.activate(
      [
        self.footerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.footerView.topAnchor.constraint(
          equalTo: self.groupListTableView.topAnchor,
          constant: Constant.Layout.Cell.height * 3
        ),
        self.footerView.leadingAnchor.constraint(equalTo: self.groupListTableView.leadingAnchor),
        self.footerView.heightAnchor.constraint(equalToConstant: Constant.Layout.FooterView.height)
      ]
    )
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
  
  // rightBarButton 특정
  viewController.rightBarButton.tintColor = .systemBlue
  
  // front로 끄집어내기
  
  // viewController.view.bringSubviewToFront(viewController.footerView)
  viewController.view.bringSubviewToFront(viewController.groupListTableView)
  
  // 편집모드 진입
  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
    viewController.setEditingMode()
  }
  // 한번더 하면 편집모드 탈출
  DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
    viewController.setEditingMode()
  }

  let navi = UINavigationController(rootViewController: viewController)
  return navi
}
#endif
