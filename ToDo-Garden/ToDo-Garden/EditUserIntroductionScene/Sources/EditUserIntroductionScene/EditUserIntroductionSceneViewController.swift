//
//  EditUserIntroductionSceneViewController.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity
import ToDoGardenUIResource

protocol EditUserIntroductionSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditUserIntroductionScene.Something.ViewModel)
}

class EditUserIntroductionSceneViewController: UIViewController, EditUserIntroductionSceneViewControllable {
  private let doneButton: UIBarButtonItem

  var interactor: EditUserIntroductionSceneBusinessLogic?
  var router: (EditUserIntroductionSceneRoutingLogic & EditUserIntroductionSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.doneButton = UIBarButtonItem()
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

extension EditUserIntroductionSceneViewController: EditUserIntroductionSceneDisplayLogic {
  func displaySomething(viewModel: EditUserIntroductionScene.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension EditUserIntroductionSceneViewController {
  func doSomething() {
    let request = EditUserIntroductionScene.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}

// MARK: - Set up UI

extension EditUserIntroductionSceneViewController {
  private func setupUI() {
    self.setupMainViewUI()
    self.setupDoneButtonTitle()
  }

  private func setupMainViewUI() {
    self.title = "소개 변경"
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupDoneButtonTitle() {
    self.doneButton.setTitlePositionAdjustment(
      UIOffset(horizontal: -10, vertical: 0),
      for: UIBarMetrics.default
    )
    self.doneButton.setTitleTextAttributes(
      [
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark,
        NSAttributedString.Key.font: UIFont.pretendardBodyRegular
      ],
      for: UIControl.State.normal
    )
    self.doneButton.title = "완료"
    self.navigationItem.rightBarButtonItem = self.doneButton
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return EditUserIntroductionSceneViewController()
}
#endif
