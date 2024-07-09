//
//  GroupSelectionView.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIConstant

public final class GroupSelectionView: UIView {
  private let model: GroupSelectionView.Model
  private let showGroupListButton: UIButton
  private let currentGroupRow: Styled.Row
  private let editableGroupListTableView: UITableView

  public init(model: GroupSelectionView.Model) {
    self.model = model
    self.showGroupListButton = UIButton()
    self.currentGroupRow = Styled.Row(
      configuration: Styled.Row.Configuration.listPrimary(
        Styled.Row.Configuration.ListPrimaryModel(
          title: Constant.GroupSelectionView.StringLiteral.defaultGroupName,
          color: UIColor.toDoGardenYellow
        )
      )
    )
    self.editableGroupListTableView = UITableView()
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension GroupSelectionView {
  private func setup() {
    self.setupShowGroupMenuButton()
    self.setupEditableGroupListTableView()
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
    }
  }

  private func animateRotatingButton(isSelected: Bool) {
    let transform = isSelected ? CGAffineTransform(rotationAngle: CGFloat.pi / 2) : CGAffineTransform.identity
    UIView.animate(withDuration: Constant.GroupSelectionView.Animation.duration) {
      self.showGroupListButton.transform = transform
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
