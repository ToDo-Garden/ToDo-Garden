//
//  GroupSelectionView.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class GroupSelectionView: UIView, GroupSelectionViewAPI {
  private let model: GroupSelectionView.Model
  private let showGroupListButton: UIButton
  private let currentGroupRow: Styled.Row
  private let editableGroupListTableView: UITableView
  private let editableGroupListTableViewDelegate: EditableGroupTableViewDelegate
  private var tableViewHeightConstraint: NSLayoutConstraint
  private var heightConstraint: NSLayoutConstraint

  public init(model: GroupSelectionView.Model) {
    self.model = model
    self.showGroupListButton = UIButton()
    self.currentGroupRow = Styled.Row(
      configuration: Styled.Row.Configuration.listPrimary(
        Styled.Row.Configuration.ListPrimaryModel(
          title: Constant.GroupSelectionView.StringLiteral.defaultGroupName,
          color: UIColor.toDoGardenYellow
        )
      ),
      with: [self.showGroupListButton]
    )
    self.editableGroupListTableView = UITableView()
    self.editableGroupListTableViewDelegate = EditableGroupTableViewDelegate(
      tableView: self.editableGroupListTableView,
      cellHeight: self.model.cellHeight
    )
    self.tableViewHeightConstraint = NSLayoutConstraint()
    self.heightConstraint = NSLayoutConstraint()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func updateGroup(
    current: any GroupSelectionViewItemAPI,
    editableList: [any GroupSelectionViewItemAPI]
  ) {
    self.editableGroupListTableViewDelegate.updateGroup(
      currentItem: current,
      editableItems: editableList
    )
  }

  public func getCurrentGroupId() -> Int? {
    return self.editableGroupListTableViewDelegate.currentGroupItem?.groupId
  }
}

protocol GroupDataSendable: AnyObject {
  func send(groupItem: EditableGroupItem?)
}

extension GroupSelectionView: GroupDataSendable {
  func send(groupItem: EditableGroupItem?) {
    guard let groupItem = groupItem
    else { return }

    let title = groupItem.groupName
    let color = groupItem.groupColor
    let model = Styled.Row.Configuration.ListPrimaryModel(title: title, color: color)
    self.currentGroupRow.groupListModel = model
  }
}

// MARK: Private Functions

extension GroupSelectionView {
  private func setup() {
    self.setupShowGroupMenuButton()
    self.setupEditableGroupListTableView()
    self.setupSelectedGroupSender()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupShowGroupMenuButton() {
    self.showGroupListButton.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)
    self.showGroupListButton.changesSelectionAsPrimaryAction = true
    self.showGroupListButton.addAction(self.makeShowEditableGroupButtonAction(), for: UIControl.Event.touchUpInside)
  }

  private func makeShowEditableGroupButtonAction() -> UIAction {
    return UIAction { [weak self] _ in
      guard let self else { return }

      let isSelected = self.showGroupListButton.isSelected
      self.animateRotatingButton(isSelected: isSelected)
      self.animateShowingEditableGroupMenu(isSelected: isSelected)
    }
  }

  private func animateRotatingButton(isSelected: Bool) {
    let transform = isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi / 2) : CGAffineTransform.identity
    UIView.animate(withDuration: Constant.GroupSelectionView.Animation.duration) {
      self.showGroupListButton.transform = transform
    }
  }

  private func animateShowingEditableGroupMenu(isSelected: Bool) {
    let height = self.model.cellHeight * CGFloat(self.model.visibleCellCount)
    let heightConstant: CGFloat = isSelected ? height : 0
    UIView.animate(withDuration: Constant.GroupSelectionView.Animation.duration) {
      self.heightConstraint.constant = heightConstant + self.model.cellHeight
      self.tableViewHeightConstraint.constant = heightConstant
      self.superview?.layoutIfNeeded()
    }
  }

  private func setupEditableGroupListTableView() {
    self.editableGroupListTableView.register(
      EditableGroupTableViewCell.self,
      forCellReuseIdentifier: EditableGroupTableViewCell.identifier
    )
    self.setupEditableGroupListTableViewUI()
  }

  private func setupEditableGroupListTableViewUI() {
    self.editableGroupListTableView.sectionHeaderTopPadding = 0
    self.editableGroupListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    let layout = Constant.GroupSelectionView.Layout.EditableGroupTableView.Layer.self
    self.editableGroupListTableView.layer.cornerRadius = layout.cornerRadius
    self.editableGroupListTableView.layer.maskedCorners = [
      CACornerMask.layerMinXMaxYCorner,
      CACornerMask.layerMaxXMaxYCorner
    ]
  }

  private func setupSelectedGroupSender() {
    self.editableGroupListTableViewDelegate.selectedGroupSender = self
  }
}

// MARK: About Auto Layout

extension GroupSelectionView {
  private func addSubviews() {
    self.addSubview(self.currentGroupRow)
  }

  private func setupSubviewsLayout() {
    self.setupCurrentGroupRowLayout()
    let containerView = self.makeGroupListContainerView()
    self.setupContainerViewLayout(containerView: containerView)
    self.setupGroupListTableViewLayout(with: containerView)
    self.setupHeightLayout()
  }

  private func setupCurrentGroupRowLayout() {
    self.currentGroupRow.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.currentGroupRow.topAnchor.constraint(equalTo: self.topAnchor),
        self.currentGroupRow.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.currentGroupRow.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.currentGroupRow.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
      ]
    )
  }

  private func makeGroupListContainerView() -> UIView {
    let containerView = UIView()
    self.setupShadowLayer(to: containerView)
    return containerView
  }

  private func setupShadowLayer(to view: UIView) {
    let layerConstant = Constant.GroupSelectionView.Layout.TableViewContainer.Layer.self
    view.layer.shadowOpacity = layerConstant.shadowOpacity
    view.layer.shadowOffset = layerConstant.shadowOffset
    view.layer.shadowRadius = layerConstant.shadowRadius
    view.layer.cornerRadius = layerConstant.cornerRadius
    view.layer.masksToBounds = false
    view.layer.maskedCorners = [
      CACornerMask.layerMinXMaxYCorner,
      CACornerMask.layerMaxXMaxYCorner
    ]
  }

  private func setupContainerViewLayout(containerView: UIView) {
    self.addSubview(containerView)
    containerView.usingAutolayout()
    self.tableViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
    self.tableViewHeightConstraint.priority = UILayoutPriority.defaultLow
    self.tableViewHeightConstraint.isActive = true

    let layout = Constant.GroupSelectionView.Layout.TableViewContainer.self
    NSLayoutConstraint.activate(
      [
        containerView.topAnchor.constraint(
          equalTo: self.currentGroupRow.bottomAnchor,
          constant: layout.topMargin
        ),
        containerView.leadingAnchor.constraint(
          equalTo: self.currentGroupRow.leadingAnchor,
          constant: layout.leadingMargin
        ),
        containerView.trailingAnchor.constraint(
          equalTo: self.currentGroupRow.trailingAnchor,
          constant: -layout.trailingMargin
        )
      ]
    )
  }

  private func setupGroupListTableViewLayout(with containerView: UIView) {
    containerView.addSubview(self.editableGroupListTableView)
    self.editableGroupListTableView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.editableGroupListTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
        self.editableGroupListTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        self.editableGroupListTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        self.editableGroupListTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
      ]
    )
  }

  private func setupHeightLayout() {
    self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
    self.heightConstraint.priority = UILayoutPriority.defaultLow
    self.heightConstraint.isActive = true
  }
}

// MARK: Model

extension GroupSelectionView {
  public struct Model {
    let cellHeight: CGFloat
    let visibleCellCount: Int

    init(cellHeight: CGFloat, visibleCellCount: Int) {
      self.cellHeight = cellHeight
      self.visibleCellCount = visibleCellCount
    }

    public static let primary = Self(
      cellHeight: Constant.GroupSelectionView.Model.Primary.cellHeight,
      visibleCellCount: Constant.GroupSelectionView.Model.Primary.visibleCellCount
    )
  }
}

@available(iOS 17.0, *)
#Preview {
  let groupSelectionView = GroupSelectionView(model: GroupSelectionView.Model.primary)
  groupSelectionView.updateGroup(
    current: EditableGroupItem(groupId: 0, groupName: "CS 지식", groupColor: UIColor.brown),
    editableList: [
      .init(groupId: 0, groupName: "CS 지식", groupColor: UIColor.brown),
      .init(groupId: 1, groupName: "영어", groupColor: UIColor.red),
      .init(groupId: 2, groupName: "국어", groupColor: UIColor.blue),
      .init(groupId: 3, groupName: "수학", groupColor: UIColor.systemMint),
      .init(groupId: 4, groupName: "Swift", groupColor: UIColor.toDoGardenYellow),
      .init(groupId: 5, groupName: "런닝", groupColor: UIColor.toDoGardenGreenDark),
      .init(groupId: 6, groupName: "지구과학", groupColor: UIColor.systemGreen),
      .init(groupId: 7, groupName: "물리", groupColor: UIColor.orange)
    ]
  )
  return groupSelectionView
}
