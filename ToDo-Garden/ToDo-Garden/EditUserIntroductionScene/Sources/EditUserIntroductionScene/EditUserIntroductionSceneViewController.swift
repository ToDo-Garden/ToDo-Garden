//
//  EditUserIntroductionSceneViewController.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Combine
import UIKit

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import ToDoGardenUIResource

protocol EditUserIntroductionSceneDisplayLogic: AnyObject {
  func displayUserIntroduction(_ introduction: String)
  func displayEmptyUserIntroduction()
  func displayUserIntroductionValid()
  func displayUserIntroductionInvalid()
  func displayEditUserIntroductionSuccess()
  func displayEditUserIntroductionFailure(_ errorMessage: String)
}

final class EditUserIntroductionSceneViewController: UIViewController, EditUserIntroductionSceneViewControllable {
  private let doneButton: UIBarButtonItem
  private let inputUserIntroductionView: InputTextValidationView

  private var inputUserNameSubject: PassthroughSubject<String, Never>
  private var cancellables: Set<AnyCancellable>

  var interactor: EditUserIntroductionSceneBusinessLogic?
  var router: (EditUserIntroductionSceneRoutingLogic & EditUserIntroductionSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.doneButton = UIBarButtonItem()
    let introductionTextConstant = ToDoGardenUIConstant.Constant.TextInputView.StringLiteral.UserIntroduction.self
    let validationTextConstant = ToDoGardenUIConstant.Constant.InputTextValidationView.StringLiteral.ValidationText.self
    self.inputUserIntroductionView = InputTextValidationView(
      inputText: introductionTextConstant.inputText,
      placeholderText: introductionTextConstant.placeholderText,
      validationText: validationTextConstant.invalidIntroduction
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
    self.interactor?.loadUserIntroduction()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.interactor?.cancelTask()
  }
}

// MARK: - Confirm display logic protocol

extension EditUserIntroductionSceneViewController: EditUserIntroductionSceneDisplayLogic {
  func displayUserIntroduction(_ introduction: String) {
    self.inputUserIntroductionView.setBeginEditing(with: introduction)
    self.doneButton.isEnabled = true
  }

  func displayEmptyUserIntroduction() {
    self.inputUserIntroductionView.setBeginEditing(with: "")
    self.doneButton.isEnabled = false
  }

  func displayUserIntroductionValid() {
    self.inputUserIntroductionView.hideValidationText()
    self.doneButton.isEnabled = true
  }

  func displayUserIntroductionInvalid() {
    self.inputUserIntroductionView.showValidationText()
    self.doneButton.isEnabled = false
  }

  func displayEditUserIntroductionSuccess() {
    self.router?.routeToUserInfoScene()
  }

  func displayEditUserIntroductionFailure(_ errorMessage: String) {
    self.showToast(message: errorMessage)
  }
}

// MARK: - Request to interactor

extension EditUserIntroductionSceneViewController {
  private func bindInputTextChanged() {
    self.inputUserIntroductionView.delegate = self
    self.inputUserNameSubject
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { [weak self] introduction in
        self?.interactor?.verifyUserIntroduction(introduction)
      }
      .store(in: &self.cancellables)
  }
}

extension EditUserIntroductionSceneViewController: InputTextValidationViewDelegate {
  func inputTextDidChanged(_ text: String?) {
    if let text {
      self.inputUserNameSubject.send(text)
    }
  }
}

// MARK: - Set up UI

extension EditUserIntroductionSceneViewController {
  private func setupUI() {
    self.setupMainViewUI()
    self.setupDoneButton()
    self.bindInputTextChanged()
    self.setupInputIntroductionViewLayout()
  }

  private func setupMainViewUI() {
    self.title = Constant.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupDoneButton() {
    self.setupDoneButtonAction()
    self.setupDoneButtonTitle()
  }

  private func setupDoneButtonAction() {
    self.doneButton.primaryAction = UIAction { [weak self] _ in
      let inputIntroduction = self?.inputUserIntroductionView.getEditingText()
      self?.interactor?.requestEditUserIntroduction(inputIntroduction)
    }
  }

  private func setupDoneButtonTitle() {
    let constant = Constant.Layout.DoneButton.self
    self.doneButton.setTitlePositionAdjustment(
      UIOffset(horizontal: -constant.horizontalOffset, vertical: 0),
      for: UIBarMetrics.default
    )
    self.doneButton.setTitleTextAttributes(
      [
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark,
        NSAttributedString.Key.font: UIFont.pretendardBodyRegular
      ],
      for: UIControl.State.normal
    )
    self.doneButton.title = Constant.StringLiteral.DoneButton.title
    self.navigationItem.rightBarButtonItem = self.doneButton
  }

  private func setupInputIntroductionViewLayout() {
    self.view.addSubview(self.inputUserIntroductionView)
    self.inputUserIntroductionView.usingAutolayout()

    let viewBounds = self.view.bounds
    let constant = Constant.Layout.InputUserIntroductionView.self
    NSLayoutConstraint.activate(
      [
        self.inputUserIntroductionView.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: viewBounds.height * constant.topMarginRatio
        ),
        self.inputUserIntroductionView.widthAnchor.constraint(
          equalToConstant: viewBounds.width * constant.widthRatio
        ),
        self.inputUserIntroductionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
      ]
    )
  }
}
