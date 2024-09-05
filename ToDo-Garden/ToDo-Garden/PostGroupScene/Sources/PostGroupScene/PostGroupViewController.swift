//
//  PostGroupViewController.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Combine
import UIKit

import PostGroupSceneAPI
import PostGroupSceneEntity
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import ToDoGardenUIResource

protocol PostGroupDisplayLogic: AnyObject {
  func displayChangedColor(viewModel: PostGroup.ChangeColor.ViewModel)
  func displayPayload(viewModel: PostGroup.LoadGroupData.ViewModel)
  func displayTouchedDondButton(viewModel: PostGroup.TouchDoneButton.ViewModel)
}

final class PostGroupViewController: UIViewController, PostGroupViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: PostGroupBusinessLogic?
  var router: PostGroupDataPassing?
  
  private let textInputView: TextInputView
  private let postGroupColorPickerRow: PostGroupColorPickerRow
  private var postGroupBottomSheet: PostGroupBottomSheet?
  private let colorPickButton: UIButton
  private let doneBottomButton: ToDoGardenBoxButton
  
  // MARK: - Object lifecycle
  
  init() {
    self.textInputView = TextInputView(model: TextInputView.Model.groupName)
    self.postGroupColorPickerRow = PostGroupColorPickerRow()
    self.colorPickButton = UIButton()
    self.doneBottomButton = ToDoGardenBoxButton(
      title: "완료",
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.white
    self.setupUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.loadGroupData()
  }
  
  private func setupUI() {
    self.setupBottomSheet()
    self.setupTextInputView()
    self.setupPostGroupColorPickerRow()
    self.setupColorPickButton()
    self.setupDoneBottomButton()
  }
  
  private func setupBottomSheet() {
    let subject = CurrentValueSubject<Int?, Never>(nil)
    let colorPickerList = ColorPickerList(
      colors: [
        UIColor.toDoGardenRed,
        UIColor.toDoGardenOrange,
        UIColor.toDoGardenYellow,
        UIColor.toDoGardenLeaf,
        UIColor.toDoGardenOlive,
        UIColor.toDoGardenMint,
        UIColor.toDoGardenBlue,
        UIColor.toDoGardenPink,
        UIColor.toDoGardenPurple,
        UIColor.toDoGardenBrown,
        UIColor.toDoGardenBlack,
        UIColor.toDoGardenGray
      ],
      itemsPerRow: Constant.ColorPickerRow.itemsPerRow,
      selected: subject
    )
    
    self.postGroupBottomSheet = PostGroupBottomSheet(
      colorPickerList: colorPickerList,
      bottomButton: ToDoGardenBoxButton(title: "완료", buttonType: .primaryRoundRectButton)
    )
    
    self.postGroupBottomSheet?.delegate = self
  }
  
  private func setupTextInputView() {
    self.textInputView.delegate = self
    self.textInputView.usingAutolayout()
    self.view.addSubview(self.textInputView)
    
    NSLayoutConstraint.activate(
      [
        self.textInputView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.TextInputView.margin
        ),
        self.textInputView.leadingAnchor.constraint(
          equalTo: self.view.leadingAnchor,
          constant: Constant.TextInputView.margin
        ),
        self.textInputView.trailingAnchor.constraint(
          equalTo: self.view.trailingAnchor,
          constant: -Constant.TextInputView.margin
        )
      ]
    )
  }
  
  private func setupPostGroupColorPickerRow() {
    self.view.addSubview(self.postGroupColorPickerRow)
    self.postGroupColorPickerRow.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.postGroupColorPickerRow.topAnchor.constraint(
          equalTo: self.textInputView.bottomAnchor,
          constant: Constant.ColorPickerRow.topMargin
        ),
        self.postGroupColorPickerRow.heightAnchor.constraint(
          equalToConstant: Constant.ColorPickerRow.height
        ),
        self.postGroupColorPickerRow.leadingAnchor.constraint(
          equalTo: self.view.leadingAnchor,
          constant: Constant.ColorPickerRow.leadingMargin
        ),
        self.postGroupColorPickerRow.trailingAnchor.constraint(
          equalTo: self.view.trailingAnchor,
          constant: Constant.ColorPickerRow.trailingMargin
        )
      ]
    )
  }
  
  private func setupColorPickButton() {
    guard let postGroupBottomSheet = postGroupBottomSheet else {
      return
    }
    
    self.colorPickButton.setImage(UIImage.forwardButtonImage, for: UIButton.State.normal)
    self.colorPickButton.usingAutolayout()
    self.view.addSubview(self.colorPickButton)
    
    NSLayoutConstraint.activate(
      [
        self.colorPickButton.centerYAnchor.constraint(equalTo: self.postGroupColorPickerRow.centerYAnchor),
        self.colorPickButton.centerXAnchor.constraint(equalTo: self.postGroupColorPickerRow.trailingAnchor),
        self.colorPickButton.widthAnchor.constraint(equalToConstant: Constant.ColorPickButton.length),
        self.colorPickButton.heightAnchor.constraint(equalToConstant: Constant.ColorPickButton.length)
      ]
    )
    
    self.colorPickButton.addAction( UIAction { _ in
      postGroupBottomSheet.setupCurrentColor(color: self.postGroupColorPickerRow.getColor())
      self.present(postGroupBottomSheet, animated: true)
    }, for: UIControl.Event.touchUpInside)
  }
  
  private func setupDoneBottomButton() {
    self.doneBottomButton.usingAutolayout()
    self.view.addSubview(self.doneBottomButton)
    self.doneBottomButton.isEnabled = self.isDoneBottomButtonEnabled()
    
    NSLayoutConstraint.activate(
      [
        self.doneBottomButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.doneBottomButton.bottomAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
          constant: Constant.BottomButton.bottomMargin
        )
      ]
    )
    
    self.doneBottomButton.addAction(
      UIAction { [weak self] _ in
        guard let groupName = self?.textInputView.getEditingText(),
          let groupColor = self?.postGroupColorPickerRow.getColor() else {
          return
        }
        
        let request = PostGroup.TouchDoneButton.Request(groupName: groupName, groupColor: groupColor)
        self?.interactor?.touchDoneButton(request: request)
      },
      for: UIControl.Event.touchUpInside
    )
  }
  
  private func isDoneBottomButtonEnabled() -> Bool {
    return !(self.isTextFieldEmpty()) && !(self.isColorEmpty())
  }
  
  private func isTextFieldEmpty() -> Bool {
    guard let currentText = self.textInputView.getEditingText() else {
      return true
    }
    
    return currentText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
  }
  
  private func isColorEmpty() -> Bool {
    guard let currentColor = self.postGroupColorPickerRow.getColor() else {
      return true
    }
    
    return currentColor == UIColor.toDoGardenGrassNone
  }
}

// MARK: - Confirm display logic protocol

extension PostGroupViewController: PostGroupDisplayLogic {
  func displayChangedColor(viewModel: PostGroupSceneEntity.PostGroup.ChangeColor.ViewModel) {
    self.postGroupColorPickerRow.updateColor(with: viewModel.groupColor)
    self.doneBottomButton.isEnabled = self.isDoneBottomButtonEnabled()
    self.textInputView.changeBottomLine(color: viewModel.groupColor)
  }
  
  func displayPayload(viewModel: PostGroupSceneEntity.PostGroup.LoadGroupData.ViewModel) {
    self.textInputView.setBeginEditing(with: viewModel.groupName)
    self.postGroupColorPickerRow.updateColor(with: viewModel.groupColor ?? UIColor.toDoGardenGrassNone)
    self.doneBottomButton.isEnabled = viewModel.isDoneBottomButtonEnable
  }
  
  func displayTouchedDondButton(viewModel: PostGroup.TouchDoneButton.ViewModel) {
    print("Route to ManageGroupScene")
  }
}

// MARK: - Request to interactor

extension PostGroupViewController {
  func loadGroupData() {
    self.interactor?.loadGroupData()
  }
}

extension PostGroupViewController: TextInputViewDelegate {
  func textInputViewDidChange() {
    self.doneBottomButton.isEnabled = self.isDoneBottomButtonEnabled()
  }
}

extension PostGroupViewController: PostGroupBottomSheetDelegate {
  func dismissedBottomSheet(color: UIColor) {
    let request = PostGroup.ChangeColor.Request(groupColor: color)
    self.interactor?.changeColor(request: request)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = PostGroupViewController()
  return viewController
}
#endif
