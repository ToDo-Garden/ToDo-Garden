//
//  ManageGroupViewController.swift
//
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ManageGroupSceneAPI
import ManageGroupSceneEntity
import TDFoundationExtension
import ToDoGardenUIAPI
import ToDoGardenUIResource

protocol ManageGroupDisplayLogic: AnyObject {
  func displayFetchedGroupList(viewModel: ManageGroup.FetchGroupList.ViewModel)
  func displayDeletedGroup(viewModel: ManageGroup.DeleteGroup.ViewModel)
  func displayReorderedGroup(viewModel: ManageGroup.ReorderGroup.ViewModel)
}

class ManageGroupViewController: UIViewController, ManageGroupViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: ManageGroupBusinessLogic?
  var router: (ManageGroupRoutingLogic & ManageGroupDataPassing)?
  
  private let groupListTableView: ManageGroupTableViewAPI
  private let groupListTableViewCell: ManageGroupTableViewCellAPI
  
  private var rightBarButton: UIBarButtonItem
  private var addGroupfooterButton: UIButton
  private var displayedGroups: [ManageGroup.ToDoGroup]
  
  private var tableViewLeadingConstraint: NSLayoutConstraint?
  private var footerViewLeadingConstraint: NSLayoutConstraint?
  
  private var manageGroupTableViewDelegate: ManageGroupTableViewDelegate?
  
  // MARK: - Object lifecycle
  
  init(
    tableView: ManageGroupTableViewAPI,
    cell: ManageGroupTableViewCellAPI,
    footerButton: UIButton
  ) {
    self.displayedGroups = ManageGroup.FetchGroupList.ViewModel(with: []).list
    self.groupListTableView = tableView
    self.groupListTableViewCell = cell
    self.addGroupfooterButton = footerButton
    self.rightBarButton = UIBarButtonItem()
    self.manageGroupTableViewDelegate = nil
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.doSomething()
  }
}

// MARK: - Confirm display logic protocol

extension ManageGroupViewController: ManageGroupDisplayLogic {
  func displaySomething(viewModel: ManageGroup.FetchGroupList.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension ManageGroupViewController {
  func doSomething() {
    let request = ManageGroup.FetchGroupList.Request()
    self.interactor?.doSomething(request: request)
  }
}
