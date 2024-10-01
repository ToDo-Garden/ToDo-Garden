//
//  ManageGroupViewControllerForUsageGuide.swift
//
//  Created by SONG on 8/24/24.
//

import UIKit

import ManageGroupScene

final class ManageGroupViewControllerForGuide: ManageGroupViewController {
  private let isEditMode: Bool
  private var editModeTask: Task<Void, Never>?
  
  init(isEditMode: Bool = false) {
    self.isEditMode = isEditMode
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.isEditMode {
      self.startEditModeTask()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.stopEditModeTask()
  }
  
  private func setupUI() {
    self.view.backgroundColor = UIColor.white
    self.setupTableView()
    self.setupNavigationBar()
    self.setupGroupList()
  }
  
  private func setupGroupList() {
    let fetchedData = ManageGroupMockData.guideSceneData
    self.manageGroupTableViewDelegate?.displayedGroups = fetchedData
    self.groupListTableView.reloadData()
  }
  
  private func setFooterViewForGuide() {
    self.footerView.usingAutolayout()
    self.view.addSubview(self.footerView)
    
    NSLayoutConstraint.activate([
      self.footerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.footerView.topAnchor.constraint(equalTo: self.groupListTableView.topAnchor, constant: 45.0 * 3),
      self.footerView.leadingAnchor.constraint(equalTo: self.groupListTableView.leadingAnchor),
      self.footerView.heightAnchor.constraint(equalToConstant: 50.0)
    ])
  }
  
  private func startEditModeTask() {
    self.editModeTask = Task { [weak self] in
      while !Task.isCancelled {
        self?.setEditingMode()
        try? await Task.sleep(nanoseconds: 2_000_000_000)
      }
    }
  }
  
  private func stopEditModeTask() {
    self.editModeTask?.cancel()
    self.editModeTask = nil
  }
}

// MARK: - Regions with Offset
extension ManageGroupViewControllerForGuide {
  func getTableViewTransparentRegion() -> DimmingView.TransparentRegion {
    let yOffset = self.calculateYOffset()
    let rect = self.groupListTableView.rect(forSection: .zero)
      .offsetBy(dx: 5.0, dy: yOffset)
      .insetBy(dx: 0, dy: 25.0)
    
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 18.0)
  }
  
  func getFooterViewTransparentRegion() -> DimmingView.TransparentRegion {
    let yOffset = self.calculateYOffset()
    let rect = self.footerView.frame(in: self.view).offsetBy(dx: 0.0, dy: yOffset)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 15.0)
  }
  
  func getRightBarButtonTransparentRegion() -> DimmingView.TransparentRegion {
    let navigationBarHeight = self.navigationController?.navigationBar.frame(in: self.view).height ?? 0
    let yOffset = self.calculateYOffset() - navigationBarHeight
    let rect = self.rightBarButton.customView?
      .frame(in: self.view)
      .offsetBy(dx: -16.5, dy: yOffset)
      .insetBy(dx: -10, dy: -5)
    
    return DimmingView.TransparentRegion(rect: rect ?? CGRect.zero, cornerRadius: 10.0)
  }
  
  private func calculateYOffset() -> CGFloat {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let statusBarHeight = scene?.statusBarManager?.statusBarFrame.height ?? 0
    let navigationBarHeight = self.navigationController?.navigationBar.frame(in: self.view).height ?? 0
    return statusBarHeight + navigationBarHeight
  }
}
