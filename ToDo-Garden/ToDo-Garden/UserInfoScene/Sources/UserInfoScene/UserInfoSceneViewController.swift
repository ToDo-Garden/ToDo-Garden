//
//  UserInfoSceneViewController.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: UserInfoScene.Something.ViewModel)
}

class UserInfoSceneViewController: UIViewController, UserInfoSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: UserInfoSceneBusinessLogic?
  var router: (UserInfoSceneRoutingLogic & UserInfoSceneDataPassing)?
  
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

extension UserInfoSceneViewController: UserInfoSceneDisplayLogic {
  func displaySomething(viewModel: UserInfoScene.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension UserInfoSceneViewController {
  func doSomething() {
    let request = UserInfoScene.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
