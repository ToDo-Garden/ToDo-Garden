//
//  EditUserNameSceneViewController.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditUserNameSceneAPI
import EditUserNameSceneEntity

protocol EditUserNameSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditUserNameScene.Something.ViewModel)
}

class EditUserNameSceneViewController: UIViewController, EditUserNameSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: EditUserNameSceneBusinessLogic?
  var router: (EditUserNameSceneRoutingLogic & EditUserNameSceneDataPassing)?
  
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return EditUserNameSceneBuilder.previewScene
}
#endif
