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

protocol PostGroupDisplayLogic: AnyObject {
  func displaySomething(viewModel: PostGroup.Something.ViewModel)
}

class PostGroupViewController: UIViewController, PostGroupViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: PostGroupBusinessLogic?
  var router: (PostGroupRoutingLogic & PostGroupDataPassing)?
  
  private let textInputView: TextInputViewAPI
  private let postGroupColorPickerRow: PostGroupColorPickerRowAPI
  private let bottomSheet: PostGroupBottomSheet
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
    self.bottomSheet = PostGroupBottomSheet(
      colorPickerList: colorPickerList,
      bottomButton: modalBottomButton
    )
    self.colorPickButton = colorPickButton
    self.doneBottomButton = bottomButton
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.white
    self.bottomSheet.delegate = self
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
      self.bottomSheet.setupCurrentColor(color: self.postGroupColorPickerRow.getColor())
      self.present(self.bottomSheet, animated: true)
    }, for: UIControl.Event.touchUpInside)
  }
}

// MARK: - Confirm display logic protocol

extension PostGroupViewController: PostGroupDisplayLogic {
  func displaySomething(viewModel: PostGroup.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension PostGroupViewController {
  func doSomething() {
    let request = PostGroup.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
