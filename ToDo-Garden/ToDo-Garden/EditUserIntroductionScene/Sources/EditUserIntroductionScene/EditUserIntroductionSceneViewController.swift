//
//  EditUserIntroductionSceneViewController.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity

protocol EditUserIntroductionSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditUserIntroductionScene.Something.ViewModel)
}

class EditUserIntroductionSceneViewController: UIViewController, EditUserIntroductionSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: EditUserIntroductionSceneBusinessLogic?
  var router: (EditUserIntroductionSceneRoutingLogic & EditUserIntroductionSceneDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return EditUserIntroductionSceneViewController()
}
#endif
