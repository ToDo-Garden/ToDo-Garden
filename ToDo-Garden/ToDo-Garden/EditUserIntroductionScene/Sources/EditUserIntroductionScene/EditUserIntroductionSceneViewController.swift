//
//  EditUserIntroductionSceneViewController.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity
import ToDoGardenUIComponent
import ToDoGardenUIConstant
import ToDoGardenUIResource

protocol EditUserIntroductionSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditUserIntroductionScene.Something.ViewModel)
}

class EditUserIntroductionSceneViewController: UIViewController, EditUserIntroductionSceneViewControllable {
  private let doneButton: UIBarButtonItem
  private let inputUserIntroductionView: InputTextValidationView

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

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.interactor?.cancelTask()
  }
}

// MARK: - Confirm display logic protocol

extension EditUserIntroductionSceneViewController: EditUserIntroductionSceneDisplayLogic {
  func displaySomething(viewModel: EditUserIntroductionScene.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension EditUserIntroductionSceneViewController {
}

// MARK: - Set up UI

extension EditUserIntroductionSceneViewController {
  private func setupUI() {
    self.setupMainViewUI()
    self.setupDoneButtonTitle()
    self.setupInputIntroductionViewLayout()
  }

  private func setupMainViewUI() {
    self.title = Constant.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: EditUserIntroductionSceneBuilder.previewScene)
}
#endif
