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
  
  private func setupNavigationBar() {
    self.navigationItem.title = Constant.StringLiteral.navigationbarTitle
    self.rightBarButton = UIBarButtonItem(
      title: Constant.StringLiteral.rightBarButtonTitleEdit,
      style: UIBarButtonItem.Style.plain,
      target: self,
      action: #selector(self.setEditingMode)
    )
    self.rightBarButton.tintColor = UIColor.toDoGardenOrange
    self.navigationItem.setRightBarButton(self.rightBarButton, animated: true)
  }
  
  @objc private func setEditingMode() {
    self.rightBarButton.isEnabled = false
    let isEditingMode = self.groupListTableView.isEditing
    self.groupListTableView.setEditingMode(!isEditingMode, animated: true)
    
    if isEditingMode {
      self.tableViewLeadingConstraint?.constant = Constant.Layout.Cell.leadingNormal
      self.footerViewLeadingConstraint?.constant = Constant.Layout.FooterView.leadingNormal
      self.rightBarButton.title = Constant.StringLiteral.rightBarButtonTitleEdit
    } else {
      self.tableViewLeadingConstraint?.constant = Constant.Layout.Cell.leadingEdit
      self.footerViewLeadingConstraint?.constant = Constant.Layout.FooterView.leadingEdit
      self.rightBarButton.title = Constant.StringLiteral.rightBarButtonTitleCancel
    }
    
    UIView.animate(withDuration: Constant.Animation.duration) { [weak self] in
      self?.view.layoutIfNeeded()
    } completion: { _ in
      if isEditingMode {
        self.interactor?.cancelEditing()
      }
      self.rightBarButton.isEnabled = true
    }
  }
  
  private func setupTableView() {
    let footerView = self.buildAddGroupFooterButton()
    
    self.manageGroupTableViewDelegate = ManageGroupTableViewDelegate(
      displayedGroups: self.displayedGroups,
      tableView: self.groupListTableView,
      cell: self.groupListTableViewCell,
      footerView: footerView,
      viewController: self
    )
    self.groupListTableView.delegate = self.manageGroupTableViewDelegate
    self.groupListTableView.dataSource = self.manageGroupTableViewDelegate
    self.groupListTableView.dragDelegate = self.manageGroupTableViewDelegate
    self.groupListTableView.dropDelegate = self.manageGroupTableViewDelegate
    
    self.setupTableViewNoBounce()
    self.setupTableViewLayout()
  }
  
  private func setupTableViewNoBounce() {
    self.groupListTableView.bounces = false
  }
  
  private func setupTableViewLayout() {
    self.view.addSubview(self.groupListTableView)
    self.groupListTableView.translatesAutoresizingMaskIntoConstraints = false
    
    self.tableViewLeadingConstraint = self.groupListTableView.leadingAnchor.constraint(
      equalTo: self.view.leadingAnchor,
      constant: Constant.Layout.TableView.leading
    )
    
    guard let tableViewLeadingConstraint = self.tableViewLeadingConstraint else {
      return
    }
    
    NSLayoutConstraint.activate(
      [
        tableViewLeadingConstraint,
        self.groupListTableView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.Layout.TableView.top
        )
      ]
    )
  }
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
