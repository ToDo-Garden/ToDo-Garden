//
//  SignUpViewController.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import SignUpSceneAPI
import SignUpSceneEntity

protocol SignUpDisplayLogic: AnyObject {
  func displaySomething(viewModel: SignUp.Something.ViewModel)
}

class SignUpViewController: UIViewController, SignUpViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SignUpBusinessLogic?
  var router: (SignUpRoutingLogic & SignUpDataPassing)?
  
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

extension SignUpViewController: SignUpDisplayLogic {
  func displaySomething(viewModel: SignUp.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension SignUpViewController {
  func doSomething() {
    let request = SignUp.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
