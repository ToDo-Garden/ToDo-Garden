//
//  EditToDoView.swift
//
//
//  Created by Wood on 7/22/24.
//

import UIKit

import ToDoGardenUIAPI

final class EditToDoView: UIView {
  private let toDoNameInputView: TextInputViewAPI
  private let groupSelectionView: GroupSelectionViewAPI
  private let deleteToDoButton: UIButton

  weak var delegate: EditToDoView.EditToDoViewDelegate?

  init(toDoNameInputView: TextInputViewAPI, groupSelectionView: GroupSelectionViewAPI) {
    self.toDoNameInputView = toDoNameInputView
    self.groupSelectionView = groupSelectionView
    self.deleteToDoButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateToDoName(_ name: String) {
    self.toDoNameInputView.setBeginEditing(with: name)
  }

  func updateGroup(
    current: EditToDoView.GroupItem,
    editableGroupList: [EditToDoView.GroupItem]
  ) {
    self.toDoNameInputView.changeBottomLine(color: current.groupColor)
    self.groupSelectionView.updateGroup(current: current, editableList: editableGroupList)
  }

  func getCurrentGroupId() -> Int? {
    return self.groupSelectionView.getCurrentGroupId()
  }

  func getEditingText() -> String? {
    return self.toDoNameInputView.getEditingText()
  }
}

// MARK: EditToDoView Delegate Functions

extension EditToDoView {
  /// EditToDoViewController가 채택할 Delegate 프로토콜입니다.
  /// EditToDoView의 Subview들에서 발생한 이벤트들을 전달하는 역할을 합니다.
  protocol EditToDoViewDelegate: AnyObject {
    func didSelectDeleteToDoButton()
  }
}

// MARK: Private Functions

extension EditToDoView {
  private func setup() {
    self.setupDeleteToDoButton()
    self.setupSubviewsLayout()
  }

  private func makeGroupLabel() -> UILabel {
    let groupLabel = UILabel()
    groupLabel.font = UIFont.pretendardHeadSemiBold
    groupLabel.textColor = EditToDoSceneTheme.mainColor
    groupLabel.text = EditToDoSceneTheme.StringLiteral.EditToDoView.GroupLabel.text
    return groupLabel
  }

  private func setupDeleteToDoButton() {
    self.deleteToDoButton.backgroundColor = UIColor.toDoGardenGreenBackground
    let cornerRadius = EditToDoViewController.Constant.Layout.EditToDoView.DeleteToDoButton.cornerRadius
    self.deleteToDoButton.layer.cornerRadius = cornerRadius
    self.deleteToDoButton.setTitleColor(UIColor.toDoGardenEditButtonRed, for: UIControl.State.normal)
    let title = NSAttributedString(
      string: EditToDoSceneTheme.StringLiteral.EditToDoView.DeleteToDoButton.title,
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadSemiBold,
        NSAttributedString.Key.strokeColor: UIColor.toDoGardenEditButtonRed
      ]
    )
    self.deleteToDoButton.setAttributedTitle(title, for: UIControl.State.normal)
    self.setupDeleteToDoButtonAction()
  }

  private func setupDeleteToDoButtonAction() {
    let deleteToDoAction = UIAction { _ in
      self.delegate?.didSelectDeleteToDoButton()
    }

    self.deleteToDoButton.addAction(deleteToDoAction, for: UIControl.Event.touchUpInside)
  }
}

// MARK: About Layout

extension EditToDoView {
  private func setupSubviewsLayout() {
    self.setupToDoNameInputViewLayout()
    let groupLabel = self.makeGroupLabel()
    self.setupGroupLabelLayout(label: groupLabel)
    self.setupGroupSelectionViewLayout(with: groupLabel)
    self.setupDeleteToDoButtonLayout()
  }

  private func setupToDoNameInputViewLayout() {
    self.addSubview(self.toDoNameInputView)
    self.toDoNameInputView.translatesAutoresizingMaskIntoConstraints = false

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.ToDoNameTextInputView.self
    NSLayoutConstraint.activate(
      [
        self.toDoNameInputView.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: layout.topMargin
        ),
        self.toDoNameInputView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        ),
        self.toDoNameInputView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.trailingMargin
        ),
        self.toDoNameInputView.heightAnchor.constraint(equalToConstant: layout.height)
      ]
    )
  }

  private func setupGroupLabelLayout(label: UILabel) {
    self.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.GroupLabel.self
    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(
          equalTo: self.toDoNameInputView.bottomAnchor,
          constant: layout.topMargin
        ),
        label.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        )
      ]
    )
  }

  private func setupGroupSelectionViewLayout(with label: UILabel) {
    self.addSubview(self.groupSelectionView)
    self.groupSelectionView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        self.groupSelectionView.topAnchor.constraint(
          equalTo: label.bottomAnchor,
          constant: 10
        ),
        self.groupSelectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.groupSelectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }

  private func setupDeleteToDoButtonLayout() {
    self.addSubview(self.deleteToDoButton)
    self.setupTitleLabelLayout(of: self.deleteToDoButton)
    self.deleteToDoButton.translatesAutoresizingMaskIntoConstraints = false

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.DeleteToDoButton.self
    NSLayoutConstraint.activate(
      [
        self.deleteToDoButton.topAnchor.constraint(
          equalTo: self.groupSelectionView.topAnchor,
          constant: 59
        ),
        self.deleteToDoButton.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        ),
        self.deleteToDoButton.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.trailingMargin
        ),
        self.deleteToDoButton.heightAnchor.constraint(equalToConstant: layout.height)
      ]
    )
  }

  private func setupTitleLabelLayout(of button: UIButton) {
    button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false

    guard let titleLabel = button.titleLabel
    else { return }

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.DeleteToDoButton.self
    NSLayoutConstraint.activate(
      [
        titleLabel.leadingAnchor.constraint(
          equalTo: self.deleteToDoButton.leadingAnchor,
          constant: layout.titleLeadingMargin
        ),
        titleLabel.centerYAnchor.constraint(equalTo: self.deleteToDoButton.centerYAnchor)
      ]
    )
  }
}

extension EditToDoView {
  struct GroupItem: GroupSelectionViewItemAPI {
    let groupId: Int
    let groupName: String
    let groupColor: UIColor

    static func < (lhs: EditToDoView.GroupItem, rhs: EditToDoView.GroupItem) -> Bool {
      lhs.groupId > rhs.groupId
    }
  }
}
