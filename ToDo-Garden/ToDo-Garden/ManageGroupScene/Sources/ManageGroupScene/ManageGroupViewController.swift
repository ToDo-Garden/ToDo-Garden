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
import ToDoGardenUIComponent
import ToDoGardenUIResource

protocol ManageGroupDisplayLogic: AnyObject {
  func displayFetchedGroupList(viewModel: ManageGroup.FetchGroupList.ViewModel)
  func displayDeletedGroup(viewModel: ManageGroup.DeleteGroup.ViewModel)
  func displayReorderedGroup(viewModel: ManageGroup.ReorderGroup.ViewModel)
}

public class ManageGroupViewController: UIViewController, ManageGroupViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: ManageGroupBusinessLogic?
  var router: (ManageGroupRoutingLogic & ManageGroupDataPassing)?

  public var rightBarButton: UIBarButtonItem
  public var footerView: UIView
  
  var displayedGroups: [ManageGroup.ToDoGroup]
  var manageGroupTableViewDelegate: ManageGroupTableViewDelegate?
  let groupListTableView: ManageGroupTableView
  
  private let groupListTableViewCell: ManageGroupTableViewCell
  
  // MARK: - Object lifecycle
  
  init() {
    self.displayedGroups = ManageGroup.FetchGroupList.ViewModel(with: []).list
    self.groupListTableView = ManageGroupTableView()
    self.groupListTableViewCell = ManageGroupTableViewCell(
      style: UITableViewCell.CellStyle.default,
      reuseIdentifier: ManageGroupTableViewCell.identifier
    )
    self.rightBarButton = UIBarButtonItem()
    self.manageGroupTableViewDelegate = nil
    self.footerView = UIView()
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupTableView()
    self.setupNavigationBar()
    self.fetchGroupList()
  }
  
  func setupNavigationBar() {
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
      self.rightBarButton.title = Constant.StringLiteral.rightBarButtonTitleEdit
    } else {
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
  
  func setupTableView() {
    self.footerView = self.buildAddGroupFooterButton()
    self.manageGroupTableViewDelegate = ManageGroupTableViewDelegate(
      displayedGroups: self.displayedGroups,
      footerView: self.footerView
    )
    
    self.groupListTableView.delegate = self.manageGroupTableViewDelegate
    self.groupListTableView.dataSource = self.manageGroupTableViewDelegate
    self.groupListTableView.dragDelegate = self.manageGroupTableViewDelegate
    self.groupListTableView.dropDelegate = self.manageGroupTableViewDelegate
    
    self.setupTouchActions()
    self.setupTableViewNoBounce()
    self.setupTableViewLayout()
  }
  
  private func setupTouchActions() {
    self.manageGroupTableViewDelegate?.setOnPostGroup { [weak self] groupName, color in
      self?.routeToPostGroupScene(groupName: groupName, color: color)
    }
    
    self.manageGroupTableViewDelegate?.setOnReorderGroups { [weak self] id, sourceIndex, destinationIndex in
      self?.addReorderedGroups(id: id, sourceIndex: sourceIndex, destinationIndex: destinationIndex)
    }
    
    self.manageGroupTableViewDelegate?.setOnDeleteGroup { [weak self] id, index in
      self?.deleteGroup(id: id, index: index)
    }
  }
  
  private func setupTableViewNoBounce() {
    self.groupListTableView.bounces = false
  }
  
  private func setupTableViewLayout() {
    self.view.addSubview(self.groupListTableView)
    self.groupListTableView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.groupListTableView.leadingAnchor.constraint(
          equalTo: self.view.leadingAnchor,
          constant: Constant.Layout.TableView.sideMargin
        ),
        self.groupListTableView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.Layout.TableView.top
        ),
        self.groupListTableView.trailingAnchor.constraint(
          equalTo: self.view.trailingAnchor,
          constant: -Constant.Layout.TableView.sideMargin)
      ]
    )
  }
  
  private func buildAddGroupFooterButton() -> UIView {
    let footerView = self.createFooterView()
    let addGroupfooterButton = UIButton(configuration: UIButton.Configuration.filled())
    self.configureFooterButton(addGroupfooterButton, on: footerView)
    self.setupFooterButtonConstraints(addGroupfooterButton, on: footerView)
    self.setupFooterButtonAction(addGroupfooterButton)
    return footerView
  }
  
  private func createFooterView() -> UIView {
    let footerView = UIView(
      frame: CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: self.groupListTableView.frame.size.width, height: Constant.Layout.FooterView.height)
      )
    )
    footerView.backgroundColor = UIColor.white
    return footerView
  }
  
  private func configureFooterButton(_ button: UIButton, on footerView: UIView) {
    footerView.addSubview(button)
    button.applyAddUnderlinedTextButtonStyle(
      with: Constant.StringLiteral.addGroupFooterButtonTitle
    )
    button.usingAutolayout()
  }
  
  private func setupFooterButtonConstraints(_ button: UIButton, on footerView: UIView) {
    
    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
      button.leadingAnchor.constraint(
        equalTo: footerView.leadingAnchor,
        constant: Constant.Layout.FooterView.buttonLeading
      ),
      button.heightAnchor.constraint(equalToConstant: Constant.Layout.FooterView.buttonHeight)
    ])
  }
  
  private func setupFooterButtonAction(_ button: UIButton) {
    button.addAction(
      UIAction { _ in
        self.routeToPostGroupScene(groupName: nil, color: nil)
      },
      for: UIControl.Event.touchUpInside
    )
  }
}

// MARK: - Confirm display logic protocol

extension ManageGroupViewController: ManageGroupDisplayLogic {
  func displayFetchedGroupList(viewModel: ManageGroup.FetchGroupList.ViewModel) {
    self.displayedGroups = viewModel.list
    self.manageGroupTableViewDelegate?.displayedGroups = viewModel.list
    self.groupListTableView.reloadData()
  }
  
  func displayDeletedGroup(viewModel: ManageGroup.DeleteGroup.ViewModel) {
    // TODO: 이후 PR에 포함될 예정
  }
  
  func displayReorderedGroup(viewModel: ManageGroup.ReorderGroup.ViewModel) {
    // TODO: 이후 PR에 포함될 예정
  }
}

// MARK: - Request to interactor

extension ManageGroupViewController {
  @objc func fetchGroupList() {
    let request = ManageGroup.FetchGroupList.Request()
    self.interactor?.fetchGroupList(request: request)
  }
  
  func deleteGroup(id: String, index: Int) {
    // TODO: 이후 PR에 포함될 예정
    print("deleteGroup, groupID: \(id), groupIndex: \(index)")
  }
  
  func reorderGroup() {
    // TODO: 이후 PR에 포함될 예정
  }
  
  func addReorderedGroups(
    id: String,
    sourceIndex: Int,
    destinationIndex: Int
  ) {
    // TODO: 이후 PR에 포함될 예정
    print("add to ReorderedGroups, groupID: \(id), sourceIndex: \(sourceIndex), destinationIndex: \(destinationIndex)")
  }
}

// MARK: - Request to interactor

extension ManageGroupViewController {
  func routeToPostGroupScene(groupName: String?, color: UIColor?) {
    guard let groupName = groupName, let color = color else {
      print("route To AddGroup")
      return
    }
    
    print("route To EditGroup with \(groupName), \(color)")
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let worker = ManageGroupWorker()
  let sceneBuilder = ManageGroupSceneBuilder(
    dependency: .init(manageGroupWorker: worker, nextSceneBuilder: nil)
  )
  
  let vcPreview = sceneBuilder.build(with: nil)
  return vcPreview
}
#endif
