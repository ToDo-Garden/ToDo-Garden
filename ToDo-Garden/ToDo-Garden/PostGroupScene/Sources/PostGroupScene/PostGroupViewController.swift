//
//  PostGroupViewController.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import PostGroupSceneAPI
import PostGroupSceneEntity
import ToDoGardenUIAPI
import ToDoGardenUIResource

protocol PostGroupDisplayLogic: AnyObject {
  func displayChangedColor(viewModel: PostGroup.ChangeColor.ViewModel)
  func displayPayload(viewModel: PostGroup.LoadGroupData.ViewModel)
  func displayTouchedDondButton(viewModel: PostGroup.TouchDoneButton.ViewModel)
}

final class PostGroupViewController: UIViewController, PostGroupViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: PostGroupBusinessLogic?
  var router: (PostGroupRoutingLogic & PostGroupDataPassing)?
  
  private let textInputView: TextInputViewAPI
  private let postGroupColorPickerRow: PostGroupColorPickerRowAPI
  private let postGroupBottomSheet: PostGroupBottomSheet
  private let colorPickButton: UIButton
  private let doneBottomButton: UIButton
  
  // MARK: - Object lifecycle
  
  init(
    textInputView: TextInputViewAPI,
    postGroupColorPickerRow: PostGroupColorPickerRowAPI,
    colorPickerList: ColorPickerListAPI,
    colorPickButton: UIButton,
    bottomButton: UIButton,
    modalBottomButton: UIButton
  ) {
    self.textInputView = textInputView
    self.postGroupColorPickerRow = postGroupColorPickerRow
    self.postGroupBottomSheet = PostGroupBottomSheet(
      colorPickerList: colorPickerList,
      bottomButton: modalBottomButton
    )
    self.colorPickButton = colorPickButton
    self.doneBottomButton = bottomButton
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.white
    self.postGroupBottomSheet.delegate = self
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: NavigationBar setup
    self.setupTextInputView()
    self.setupPostGroupColorPickerRow()
    self.setupColorPickButton()
    self.setupDoneBottomButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.loadGroupData()
  }
  private func setupTextInputView() {
    self.textInputView.delegate = self
    self.textInputView.translatesAutoresizingMaskIntoConstraints = false
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
    self.postGroupColorPickerRow.translatesAutoresizingMaskIntoConstraints = false
    
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
    self.colorPickButton.translatesAutoresizingMaskIntoConstraints = false
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
      self.postGroupBottomSheet.setupCurrentColor(color: self.postGroupColorPickerRow.getColor())
      self.present(self.postGroupBottomSheet, animated: true)
    }, for: UIControl.Event.touchUpInside)
  }
  
  private func setupDoneBottomButton() {
    self.doneBottomButton.translatesAutoresizingMaskIntoConstraints = false
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

// MARK: Preview : PostGroupScene의 Package.swift에 있는 주석처리를 해제해주세요.
//
// import Combine
// import ToDoGardenUIComponent
// #if DEBUG
// @available(iOS 17.0, *)
// #Preview {
//  let textInputView = TextInputView(model: .groupName)
//  let colorPickerRow = PostGroupColorPickerRow()
//  let subject =  CurrentValueSubject<Int?, Never>(nil)
//  let colorPickerList = ColorPickerList(colors: [
//    .toDoGardenBlack,
//    .toDoGardenBlue,
//    .toDoGardenBrown,
//    .toDoGardenEditButtonBlue,
//    .toDoGardenEditButtonRed,
//    .toDoGardenEditButtonYellow,
//    .toDoGardenGrassHigh,
//    .toDoGardenGrassLow,
//    .toDoGardenGrassMiddle,
//    .toDoGardenGray2,
//    .toDoGardenOlive,
//    .toDoGardenPink
//  ], itemsPerRow: 6, selected: subject)
//  let colorPickButton = UIButton()
//  colorPickButton.setImage(UIImage.forwardButtonImage, for: .normal)
//
//  let vc = PostGroupViewController(
//    textInputView: textInputView,
//    postGroupColorPickerRow: colorPickerRow,
//    colorPickerList: colorPickerList,
//    colorPickButton: colorPickButton,
//    bottomButton: ToDoGardenBoxButton(title: "확인", buttonType: .primaryRoundRectButton),
//    modalBottomButton: ToDoGardenBoxButton(title: "확인", buttonType: .primaryRoundRectButton)
//  )
//
//  return vc
// }
// #endif
