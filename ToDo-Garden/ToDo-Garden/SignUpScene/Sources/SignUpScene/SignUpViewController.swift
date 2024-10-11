//
//  SignUpViewController.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import SignUpSceneAPI
import SignUpSceneEntity
import ToDoGardenUIComponent

protocol SignUpDisplayLogic: AnyObject {
  func displaySomething(viewModel: SignUp.Something.ViewModel)
}

final class SignUpViewController: UIViewController, SignUpViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SignUpBusinessLogic?
  var router: (SignUpRoutingLogic & SignUpDataPassing)?
  
  private let signUpScrollView: SignUpScrollView
  private let bottomButton: ToDoGardenBoxButton
  
  // MARK: - Object lifecycle
  
  init() {
    self.signUpScrollView = SignUpScrollView()
    self.bottomButton = ToDoGardenBoxButton(
      title: Constant.BottomButton.StringLiteral.done,
      buttonType: ToDoGardenBoxButton.Configuration.rectangleButton
    )
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.white
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
