//
//  ManageGroupViewControllerForUsageGuide.swift
//
//  Created by SONG on 8/24/24.
//

import UIKit

import ManageGroupScene

public final class ManageGroupViewControllerForGuide: ManageGroupViewController {
  private let isEditMode: Bool
  private var editModeTask: Task<Void, Never>?
  
  public init(isEditMode: Bool = false) {
    self.isEditMode = isEditMode
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.isEditMode {
      self.startEditModeTask()
    }
  }
  
  override public func viewDidDisappear(_ animated: Bool) {
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
