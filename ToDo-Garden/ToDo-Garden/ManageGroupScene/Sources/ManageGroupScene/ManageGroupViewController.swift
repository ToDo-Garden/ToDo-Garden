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
  func displaySavedGroupList(viewModel: ManageGroup.SaveGroupList.ViewModel)
  func displayDeletedGroup(viewModel: ManageGroup.DeleteGroup.ViewModel)
}

public class ManageGroupViewController: UIViewController, ManageGroupViewControllable {
  // MARK: - VIP Properties
  
  var interactor: ManageGroupBusinessLogic?
  var router: (ManageGroupRoutingLogic & ManageGroupDataPassing)?
  var manageGroupTableViewDelegate: ManageGroupTableViewDelegate?
  let groupListTableView: ManageGroupTableView
  public var rightBarButton: UIBarButtonItem
  public var footerView: UIView
  private let groupListTableViewCell: ManageGroupTableViewCell
  private var editModeLeftBarButton: UIBarButtonItem
  // MARK: - Object lifecycle
  
  init() {
    self.groupListTableView = ManageGroupTableView()
    self.groupListTableViewCell = ManageGroupTableViewCell(
      style: UITableViewCell.CellStyle.default,
      reuseIdentifier: ManageGroupTableViewCell.identifier
    )
    self.rightBarButton = UIBarButtonItem()
    self.editModeLeftBarButton = UIBarButtonItem()
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
  
  // MARK: - Request to interactor
  func fetchGroupList() {
    let request = ManageGroup.FetchGroupList.Request()
    Task {
      await interactor?.fetchGroupList(request: request)
    }
  }
  
  func saveGroupList() {
    let groupList = self.manageGroupTableViewDelegate?.displayedGroups
    let request = ManageGroup.SaveGroupList.Request(with: groupList ?? [] )
    Task {
      await interactor?.saveGroupList(request: request)
    }
  }
  
  func deleteGroup(groupID: UUID, index: Int) {
    let request = ManageGroup.DeleteGroup.Request(groupID: groupID, index: index)
    self.interactor?.deleteGroup(request: request)
  }
  
  func cancelEditing() {
    let oldGroups = self.manageGroupTableViewDelegate?.displayedGroups
    let newGroups = self.manageGroupTableViewDelegate?.displayedGroupsBeforeEditing
    self.manageGroupTableViewDelegate?.displayedGroups =
    self.manageGroupTableViewDelegate?.displayedGroupsBeforeEditing ?? []
    self.updateTableViewWithAnimation(oldGroups: oldGroups ?? [], newGroups: newGroups ?? [])
    self.manageGroupTableViewDelegate?.saveDisplayGroupsBeforeEditing()
  }
}

// MARK: - Setup
extension ManageGroupViewController {
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
    self.editModeLeftBarButton = UIBarButtonItem(
      title: Constant.StringLiteral.leftBarButtonTitleSave,
      style: UIBarButtonItem.Style.plain,
      target: self,
      action: #selector(self.saveAndOutEditingMode)
    )
    self.editModeLeftBarButton.tintColor = UIColor.toDoGardenGreenDark
    self.navigationItem.setLeftBarButton(nil, animated: true)
  }
  
  @objc private func setEditingMode() {
    let isEditingMode = self.groupListTableView.isEditing
    self.updateBarButtonItems(isEditingMode: isEditingMode)
    if isEditingMode {
      self.cancelEditing()
    }
    self.rightBarButton.isEnabled = true
  }
  
  @objc private func saveAndOutEditingMode() {
    let isEditingMode = self.groupListTableView.isEditing
    self.updateBarButtonItems(isEditingMode: isEditingMode)
    if isEditingMode {
      self.saveGroupList()
    }
    self.rightBarButton.isEnabled = true
  }
  
  private func updateBarButtonItems(isEditingMode: Bool) {
    self.groupListTableView.setEditingMode(!isEditingMode, animated: true)
    if isEditingMode {
      self.rightBarButton.title = Constant.StringLiteral.rightBarButtonTitleEdit
      self.navigationItem.setLeftBarButton(nil, animated: true)
    } else {
      self.navigationItem.setLeftBarButton(self.editModeLeftBarButton, animated: true)
      self.rightBarButton.title = Constant.StringLiteral.rightBarButtonTitleCancel
      self.manageGroupTableViewDelegate?.displayedGroupsBeforeEditing =
      self.manageGroupTableViewDelegate?.displayedGroups ?? []
    }
  }
  
  func setupTableView() {
    self.footerView = self.buildAddGroupFooterButton()
    self.manageGroupTableViewDelegate = ManageGroupTableViewDelegate(
      displayedGroups: [],
      footerView: self.footerView
    )
    self.groupListTableView.delegate = self.manageGroupTableViewDelegate
    self.groupListTableView.dataSource = self.manageGroupTableViewDelegate
    self.groupListTableView.dragDelegate = self.manageGroupTableViewDelegate
    self.groupListTableView.dropDelegate = self.manageGroupTableViewDelegate
    self.setupTouchActions()
    self.setupTableViewNoBounce()
    self.setupTableViewLayout()
    self.manageGroupTableViewDelegate?.setOnReorderingStateChange { [weak self] isReordering in
      self?.rightBarButton.isEnabled = !isReordering
    }
  }
  
  private func setupTouchActions() {
    self.manageGroupTableViewDelegate?.setOnPostGroup { [weak self] groupID, groupName, groupColor in
      let groupInfo = ManageGroup.ToDoGroup(
        groupID: groupID,
        groupName: groupName,
        progressColor: groupColor,
        progressRate: Float.zero
      )
      self?.routeToPostGroupScene(groupInfo: groupInfo)
    }
    
    self.manageGroupTableViewDelegate?.setOnDeleteGroup { [weak self] groupID, index in
      self?.deleteGroup(groupID: groupID, index: index)
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
          constant: -Constant.Layout.TableView.sideMargin
        ),
        self.groupListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
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
        self.routeToPostGroupScene(groupInfo: nil)
      },
      for: UIControl.Event.touchUpInside
    )
  }
}

// MARK: - Confirm display logic protocol

extension ManageGroupViewController: ManageGroupDisplayLogic {
  
  func displayFetchedGroupList(viewModel: ManageGroup.FetchGroupList.ViewModel) {
    let oldGroups = self.manageGroupTableViewDelegate?.displayedGroups
    let newGroups = viewModel.list
    self.manageGroupTableViewDelegate?.displayedGroups = newGroups
    self.updateTableViewWithAnimation(oldGroups: oldGroups ?? [], newGroups: newGroups)
  }
  
  func displaySavedGroupList(viewModel: ManageGroup.SaveGroupList.ViewModel) {
    let oldGroups = self.manageGroupTableViewDelegate?.displayedGroups
    let newGroups = viewModel.list
    self.manageGroupTableViewDelegate?.displayedGroups = newGroups
    self.updateTableViewWithAnimation(oldGroups: oldGroups ?? [], newGroups: newGroups)
  }
  
  func displayDeletedGroup(viewModel: ManageGroup.DeleteGroup.ViewModel) {
    let index = viewModel.index
    Task { @MainActor in
      self.manageGroupTableViewDelegate?.displayedGroups.remove(at: index)
      self.groupListTableView.deleteRows(
        at: [IndexPath(row: index, section: 0)],
        with: UITableView.RowAnimation.fade
      )
    }
  }
  
  private func updateTableViewWithAnimation(
    oldGroups: [ManageGroup.ToDoGroup],
    newGroups: [ManageGroup.ToDoGroup]
  ) {
    let changes = calculateTableViewChanges(oldGroups: oldGroups, newGroups: newGroups)
    self.rightBarButton.isEnabled = false
    Task { @MainActor in
      self.groupListTableView.performBatchUpdates({
        self.groupListTableView.insertRows(
          at: changes.insertions,
          with: UITableView.RowAnimation.fade
        )
        changes.moves.forEach { move in
          self.groupListTableView.moveRow(at: move.from, to: move.to)
        }
      }, completion: { _ in
        self.groupListTableView.reloadRows(
          at: changes.updates,
          with: UITableView.RowAnimation.none
        )
        self.rightBarButton.isEnabled = true
      })
    }
  }
  
  // swiftlint:disable large_tuple
  private func calculateTableViewChanges(
    oldGroups: [ManageGroup.ToDoGroup],
    newGroups: [ManageGroup.ToDoGroup]
  ) -> (
    insertions: [IndexPath],
    moves: [(from: IndexPath, to: IndexPath)],
    updates: [IndexPath]
  ) {
    let oldIDs = oldGroups.map { $0.groupID }
    let newIDs = newGroups.map { $0.groupID }
    
    let insertions = calculateInsertions(newIDs: newIDs, oldIDs: Set(oldIDs))
    let oldIndexMap = createOldIndexMap(oldGroups: oldGroups)
    let (moves, updates) = calculateMovesAndUpdates(
      newGroups: newGroups,
      oldGroups: oldGroups,
      oldIndexMap: oldIndexMap
    )
    return (insertions, moves, updates)
  }
  // swiftlint:enable large_tuple
  
  private func calculateInsertions(newIDs: [UUID], oldIDs: Set<UUID>) -> [IndexPath] {
    var insertions: [IndexPath] = []
    for (newIndex, newID) in newIDs.enumerated() where !oldIDs.contains(newID) {
      insertions.append(IndexPath(row: newIndex, section: 0))
    }
    return insertions
  }
  
  private func createOldIndexMap(oldGroups: [ManageGroup.ToDoGroup]) -> [UUID: Int] {
    var oldIndexMap = [UUID: Int]()
    for (index, group) in oldGroups.enumerated() {
      oldIndexMap[group.groupID] = index
    }
    return oldIndexMap
  }
  
  private func calculateMovesAndUpdates(
    newGroups: [ManageGroup.ToDoGroup],
    oldGroups: [ManageGroup.ToDoGroup],
    oldIndexMap: [UUID: Int]
  ) -> (
    moves: [(from: IndexPath, to: IndexPath)],
    updates: [IndexPath]
  ) {
    var moves: [(from: IndexPath, to: IndexPath)] = []
    var updates: [IndexPath] = []
    for (newIndex, newGroup) in newGroups.enumerated() {
      if let oldIndex = oldIndexMap[newGroup.groupID] {
        if oldIndex != newIndex {
          moves.append(
            (from: IndexPath(row: oldIndex, section: 0),
            to: IndexPath(row: newIndex, section: 0))
          )
        } else if oldGroups[oldIndex] != newGroup {
          updates.append(IndexPath(row: newIndex, section: 0))
        }
      }
    }
    moves.sort { $0.from.row > $1.from.row }
    return (moves, updates)
  }
}

extension ManageGroupViewController {
  func routeToPostGroupScene(groupInfo: ManageGroup.ToDoGroup?) {
    guard let groupInfo = groupInfo else {
      self.router?.routeToPostGroupScene(groupInfo: nil)
      return
    }
    
    self.router?.routeToPostGroupScene(groupInfo: groupInfo)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let worker = ManageGroupWorker()
  let sceneBuilder = ManageGroupSceneBuilder(
    dependency: .init(manageGroupWorker: worker, postGroupSceneBuilder: nil)
  )
  let naviController = UINavigationController(rootViewController: sceneBuilder.build(with: nil))
  return naviController
}
#endif
