//
//  EditUserNameSceneViewController.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditUserNameSceneAPI
import EditUserNameSceneEntity
import ToDoGardenUIResource

protocol EditUserNameSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditUserNameScene.Something.ViewModel)
}

final class EditUserNameSceneViewController: UIViewController, EditUserNameSceneViewControllable {
  private let editUserNameButton: UIBarButtonItem

  var interactor: EditUserNameSceneBusinessLogic?
  var router: (EditUserNameSceneRoutingLogic & EditUserNameSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.editUserNameButton = UIBarButtonItem()
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
    self.doSomething()
  }
}

// MARK: - Confirm display logic protocol

extension EditUserNameSceneViewController: EditUserNameSceneDisplayLogic {
  func displaySomething(viewModel: EditUserNameScene.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension EditUserNameSceneViewController {
  func doSomething() {
    let request = EditUserNameScene.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}

// MARK: - Set up UI

extension EditUserNameSceneViewController {
  private func setupUI() {
    self.setupMainView()
    self.setupEditUserNameButton()
  }

  private func setupMainView() {
    self.title = Constant.StringLiteral.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupEditUserNameButton() {
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
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: EditUserNameSceneBuilder.previewScene)
}
#endif
