//
//  GroupSelectionView.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class GroupSelectionView: UIView {
  private let model: GroupSelectionView.Model
  private let showGroupListButton: UIButton
  private let currentGroupRow: Styled.Row
  private let groupListSeparatorLineView: UIView
  private let groupListTableView: UITableView
  private let groupListTableViewDelegate: GroupListTableViewDelegate
  private var tableViewHeightConstraint: NSLayoutConstraint
  private var heightConstraint: NSLayoutConstraint

  public weak var delegate: GroupSelectionViewDelegate?

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
    self.groupListSeparatorLineView = UIView()
    self.groupListTableView = UITableView()
    self.groupListTableViewDelegate = GroupListTableViewDelegate(
      tableView: self.groupListTableView,
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
    current: GroupSelectionViewItem,
    editableList: [GroupSelectionViewItem]
  ) {
    self.groupListTableViewDelegate.updateGroup(
      currentItem: current,
      editableItems: editableList
    )
  }

  public func getCurrentGroupId() -> Int? {
    return self.groupListTableViewDelegate.currentGroupItem?.groupId
  }
}

public protocol GroupSelectionViewDelegate: AnyObject {
  func didSelectGroup(color: UIColor)
}

extension GroupSelectionView: GroupListSelectionDelegate {
  func send(groupItem: GroupSelectionViewItem?) {
    guard let groupItem = groupItem
    else { return }

    let title = groupItem.groupName
    let color = groupItem.groupColor
    let model = Styled.Row.Configuration.ListPrimaryModel(title: title, color: color)
    self.currentGroupRow.groupListModel = model
    self.delegate?.didSelectGroup(color: color)
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

    let buttonAction = UIAction { [weak self] _ in
      guard let self else { return }

      let isSelected = self.showGroupListButton.isSelected
      self.showGroupListButton.animateRotating(with: Constant.GroupSelectionView.Animation.duration)
      self.animateShowingEditableGroupMenu(isSelected: isSelected)
    }
    self.showGroupListButton.addAction(buttonAction, for: UIControl.Event.touchUpInside)
  }

  private func animateShowingEditableGroupMenu(isSelected: Bool) {
    let height = self.model.cellHeight * CGFloat(self.model.visibleCellCount)
    let heightConstant: CGFloat = isSelected ? 0 : height
    let isSeparatorLineHidden = isSelected
    UIView.animate(withDuration: Constant.GroupSelectionView.Animation.duration) {
      self.heightConstraint.constant = heightConstant + self.model.cellHeight
      self.tableViewHeightConstraint.constant = heightConstant
      self.groupListSeparatorLineView.isHidden = isSeparatorLineHidden
      self.superview?.layoutIfNeeded()
    }
  }

  private func setupEditableGroupListTableView() {
    self.groupListTableView.register(
      GroupSelectionViewCell.self,
      forCellReuseIdentifier: GroupSelectionViewCell.identifier
    )
    self.setupEditableGroupListTableViewUI()
  }

  private func setupEditableGroupListTableViewUI() {
    self.groupListTableView.sectionHeaderTopPadding = 0
    self.groupListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    let layout = Constant.GroupSelectionView.Layout.EditableGroupTableView.Layer.self
    self.groupListTableView.layer.cornerRadius = layout.cornerRadius
    self.groupListTableView.layer.maskedCorners = [
      CACornerMask.layerMinXMaxYCorner,
      CACornerMask.layerMaxXMaxYCorner
    ]
  }

  private func setupSelectedGroupSender() {
    self.groupListTableViewDelegate.groupListSelectionDelegate = self
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
    self.setupGroupListSeparatorLineViewLayout(with: containerView)
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

  private func setupGroupListSeparatorLineViewLayout(with containerView: UIView) {
    self.groupListSeparatorLineView.isHidden = true
    self.groupListSeparatorLineView.backgroundColor = UIColor.toDoGardenGreenGray
    containerView.addSubview(self.groupListSeparatorLineView)
    self.groupListSeparatorLineView.usingAutolayout()

    let height = Constant.GroupSelectionView.Layout.EditableGroupTableViewDelegate.headerViewHeight
    NSLayoutConstraint.activate(
      [
        self.groupListSeparatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor),
        self.groupListSeparatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        self.groupListSeparatorLineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        self.groupListSeparatorLineView.heightAnchor.constraint(equalToConstant: height)
      ]
    )
  }

  private func setupGroupListTableViewLayout(with containerView: UIView) {
    containerView.addSubview(self.groupListTableView)
    self.groupListTableView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.groupListTableView.topAnchor.constraint(equalTo: self.groupListSeparatorLineView.bottomAnchor),
        self.groupListTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        self.groupListTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        self.groupListTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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

/// 그룹 정보를 업데이트하는 GroupSelectionViewItemAPI의 구체타입이 선언되어 있지 않습니다.
/// Preview로 동작을 확인하고 싶으시다면 EditableGroupItem에 GroupSelectionViewItemAPI 프로토콜을 채택 후
/// 주석을 코드로 변환해주세요
@available(iOS 17.0, *)
#Preview {
  let groupSelectionView = GroupSelectionView(model: GroupSelectionView.Model.primary)
//  groupSelectionView.updateGroup(
//    current: EditableGroupItem(groupId: 0, groupName: "CS 지식", groupColor: UIColor.brown),
//    editableList: [
//      EditableGroupItem(groupId: 0, groupName: "CS 지식", groupColor: UIColor.brown),
//      EditableGroupItem(groupId: 1, groupName: "영어", groupColor: UIColor.red),
//      EditableGroupItem(groupId: 2, groupName: "국어", groupColor: UIColor.blue),
//      EditableGroupItem(groupId: 3, groupName: "수학", groupColor: UIColor.systemMint),
//      EditableGroupItem(groupId: 4, groupName: "Swift", groupColor: UIColor.toDoGardenYellow),
//      EditableGroupItem(groupId: 5, groupName: "런닝", groupColor: UIColor.toDoGardenGreenDark),
//      EditableGroupItem(groupId: 6, groupName: "지구과학", groupColor: UIColor.systemGreen),
//      EditableGroupItem(groupId: 7, groupName: "물리", groupColor: UIColor.orange)
//    ]
//  )
  return groupSelectionView
}
