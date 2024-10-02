//
//  LoginViewController.swift
//  
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import LoginSceneAPI
import LoginSceneEntity

protocol LoginDisplayLogic: AnyObject {
  func displaySomething(viewModel: Login.Something.ViewModel)
}

class LoginViewController: UIViewController, LoginViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: LoginBusinessLogic?
  var router: (LoginRoutingLogic & LoginDataPassing)?
  
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

extension LoginViewController: LoginDisplayLogic {
  func displaySomething(viewModel: Login.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension LoginViewController {
  func doSomething() {
    let request = Login.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
