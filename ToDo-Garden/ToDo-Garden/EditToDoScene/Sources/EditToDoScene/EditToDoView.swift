//
//  EditToDoView.swift
//
//
//  Created by Wood on 7/22/24.
//

import UIKit

import EditToDoSceneEntity
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant

final class EditToDoView: UIView {
  private let toDoNameInputView: TextInputView
  private let groupSelectionView: GroupSelectionView
  private let deleteToDoButton: UIButton

  weak var delegate: EditToDoView.EditToDoViewDelegate?

  init() {
    let constant = ToDoGardenUIConstant.Constant.TextInputView.StringLiteral.ToDoName.self
    self.toDoNameInputView = TextInputView(
      inputText: constant.inputText,
      placeholderText: constant.placeholderText
    )
    self.groupSelectionView = GroupSelectionView(model: GroupSelectionView.Model.primary)
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

  func updateGroup(current: EditToDo.DisplayedGroup) {
    self.toDoNameInputView.changeBottomLine(color: current.color)
    let currentItem = self.makeGroupSelectionViewItem(from: current)
    self.groupSelectionView.updateGroup(current: currentItem)
  }

  func updateGroupList(_ list: [EditToDo.DisplayedGroup]) {
    let groupList = list.map { self.makeGroupSelectionViewItem(from: $0) }
    self.groupSelectionView.updateGroupList(groupList)
  }

  func getEditingText() -> String? {
    return self.toDoNameInputView.getEditingText()
  }

  public func getCurrentGroup() -> GroupSelectionViewItem? {
    return self.groupSelectionView.getCurrentGroup()
  }
}

// MARK: EditToDoView Delegate Functions

extension EditToDoView {
  /// EditToDoViewController가 채택할 Delegate 프로토콜입니다.
  /// EditToDoView의 Subview들에서 발생한 이벤트들을 전달하는 역할을 합니다.
  protocol EditToDoViewDelegate: AnyObject {
    func didSelectDeleteToDoButton()
    func didEditToDoName(_ name: String?)
  }
}

// MARK: GroupSelectionView Delegate Functions

extension EditToDoView: GroupSelectionViewDelegate, TextInputViewDelegate {
  func textInputViewDidChange() {
    let editedName = self.toDoNameInputView.getEditingText()
    self.delegate?.didEditToDoName(editedName)
  }

  func didSelectGroup(color: UIColor) {
    self.toDoNameInputView.changeBottomLine(color: color)
  }

  private func setupGroupSelectionViewDelegate() {
    self.groupSelectionView.delegate = self
  }
}

// MARK: Tap Gesture Functions

extension EditToDoView: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldReceive touch: UITouch
  ) -> Bool {
    self.inActiveNameEditModeWhenTouchEmptySpace(touch)
  }

  private func inActiveNameEditModeWhenTouchEmptySpace(_ touch: UITouch) -> Bool {
    guard touch.view == self
    else { return false }

    if self.toDoNameInputView.isFirstResponder {
      _ = self.toDoNameInputView.resignFirstResponder()
    }

    return true
  }

  private func setupTapGestureDelegate() {
    let tapGestureRecognizer = UITapGestureRecognizer()
    self.addGestureRecognizer(tapGestureRecognizer)
    tapGestureRecognizer.delegate = self
  }
}

// MARK: Private Functions

extension EditToDoView {
  private func setup() {
    self.setupDeleteToDoButton()
    self.setupToDoNameInputViewDelegate()
    self.setupGroupSelectionViewDelegate()
    self.setupTapGestureDelegate()
    self.setupSubviewsLayout()
  }

  private func setupToDoNameInputViewDelegate() {
    self.toDoNameInputView.delegate = self
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

  private func makeGroupSelectionViewItem(
    from group: EditToDo.DisplayedGroup
  ) -> GroupSelectionViewItem {
    return GroupSelectionViewItem(
      groupId: group.id,
      groupName: group.name,
      groupColor: group.color
    )
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

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.GroupSelectionView.self
    NSLayoutConstraint.activate(
      [
        self.groupSelectionView.topAnchor.constraint(
          equalTo: label.bottomAnchor,
          constant: layout.topMargin
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
    self.sendSubviewToBack(self.deleteToDoButton)

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.DeleteToDoButton.self
    NSLayoutConstraint.activate(
      [
        self.deleteToDoButton.topAnchor.constraint(
          equalTo: self.groupSelectionView.topAnchor,
          constant: layout.topMargin
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
  func setForGuide() {
    let text = "영어독해"
    self.toDoNameInputView.setBeginEditing(with: text)
    self.toDoNameInputView.changeBottomLine(color: UIColor.toDoGardenYellow)
    self.groupSelectionView.updateGroup(
      current: GroupSelectionViewItem(
        groupId: UUID().uuidString,
        groupName: text,
        groupColor: UIColor.toDoGardenYellow
      )
    )
  }
  
  func getToDoNameInputView() -> UIView {
    return self.toDoNameInputView
  }
  
  func getGroupSelectionView() -> UIView {
    return self.groupSelectionView
  }
}
