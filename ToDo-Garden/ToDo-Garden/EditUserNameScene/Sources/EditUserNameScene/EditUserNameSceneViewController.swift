//
//  EditUserNameSceneViewController.swift
//
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Combine
import UIKit

import EditUserNameSceneAPI
import EditUserNameSceneEntity
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import ToDoGardenUIResource

protocol EditUserNameSceneDisplayLogic: AnyObject {
  func displayUserName(_ userName: String)
  func displayEmptyUserName()
  func displayUserNameValid()
  func displayUserNameInvalid()
  func displayEditUserNameSuccess()
}

final class EditUserNameSceneViewController: UIViewController, EditUserNameSceneViewControllable {
  private let editUserNameButton: UIBarButtonItem
  private let inputUserNameView: InputTextValidationView

  private var inputUserNameSubject: PassthroughSubject<String, Never>
  private var cancellables: Set<AnyCancellable>

  var interactor: EditUserNameSceneBusinessLogic?
  var router: (EditUserNameSceneRoutingLogic & EditUserNameSceneDataPassing)?

  // MARK: - Object lifecycle

  init() {
    self.editUserNameButton = UIBarButtonItem()
    let constant = ToDoGardenUIConstant.Constant.TextInputView.StringLiteral.UserName.self
    let validationTextConstant = ToDoGardenUIConstant.Constant.InputTextValidationView.StringLiteral.ValidationText.self
    self.inputUserNameView = InputTextValidationView(
      inputText: constant.inputText,
      placeholderText: constant.placeholderText,
      validationText: validationTextConstant.invalidNickname
    )
    self.inputUserNameSubject = PassthroughSubject<String, Never>()
    self.cancellables = Set<AnyCancellable>()
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }

  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.interactor?.setUserName()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.interactor?.cancelAllTasks()
  }

  deinit {
    self.interactor?.cancelAllTasks()
  }
}

// MARK: - Confirm display logic protocol

extension EditUserNameSceneViewController: EditUserNameSceneDisplayLogic {
  func displayUserName(_ userName: String) {
    self.inputUserNameView.setBeginEditing(with: userName)
    self.editUserNameButton.isEnabled = true
  }
  
  func displayEmptyUserName() {
    self.inputUserNameView.setBeginEditing(with: "")
    self.editUserNameButton.isEnabled = false
  }

  func displayUserNameInvalid() {
    self.inputUserNameView.showValidationText()
    self.editUserNameButton.isEnabled = false
  }

  func displayUserNameValid() {
    self.inputUserNameView.hideValidationText()
    self.editUserNameButton.isEnabled = true
  }

  func displayEditUserNameSuccess() {
    self.router?.routeToUserInfoScene()
  }
}

// MARK: - Request to interactor

extension EditUserNameSceneViewController {
  private func bindInputTextChanged() {
    self.inputUserNameView.delegate = self
    self.inputUserNameSubject
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { [weak self] inputUserName in
        self?.interactor?.verifyUserName(inputUserName)
      }
      .store(in: &self.cancellables)
  }

  private func setupEditUserNameButtonAction() {
    self.editUserNameButton.primaryAction = UIAction { [weak self] _ in
      guard let self else { return }

      if let userName = self.inputUserNameView.getEditingText() {
        self.interactor?.requestEditUserName(userName)
      }
    }
  }
}

// MARK: - Subview Delegate Functions

extension EditUserNameSceneViewController: InputTextValidationViewDelegate {
  func inputTextDidChanged(_ text: String?) {
    if let inputUserName = self.inputUserNameView.getEditingText() {
      self.inputUserNameSubject.send(inputUserName)
    }
  }
}

// MARK: - Set up UI

extension EditUserNameSceneViewController {
  private func setupUI() {
    self.setupMainView()
    self.setupEditUserNameButton()
    self.bindInputTextChanged()
    self.setupInputNameViewLayout()
  }

  private func setupMainView() {
    self.title = Constant.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupEditUserNameButton() {
    self.setupEditUserNameButtonAction()
    let horizontalOffset = Constant.Layout.EditUserNameButton.titleHorizontalOffset
    self.editUserNameButton.setTitlePositionAdjustment(
      UIOffset(horizontal: -horizontalOffset, vertical: 0),
      for: UIBarMetrics.default
    )
    self.editUserNameButton.setTitleTextAttributes(
      [
        NSAttributedString.Key.foregroundColor: EditUserNameSceneTheme.mainColor,
        NSAttributedString.Key.font: UIFont.pretendardBodyRegular
      ],
      for: UIControl.State.normal
    )
    self.editUserNameButton.title = Constant.StringLiteral.EditUserNameButton.title
    self.navigationItem.rightBarButtonItem = self.editUserNameButton
  }

  private func setupInputNameViewLayout() {
    self.view.addSubview(self.inputUserNameView)
    self.inputUserNameView.usingAutolayout()

    let constant = Constant.Layout.InputUserNameView.self
    let screenSize = self.view.bounds
    NSLayoutConstraint.activate(
      [
        self.inputUserNameView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: screenSize.height * constant.topMargin
        ),
        self.inputUserNameView.widthAnchor.constraint(equalToConstant: screenSize.width * constant.widthRatio),
        self.inputUserNameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
      ]
    )
  }
}
