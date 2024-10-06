//
//  InputIDViewController.swift
//  
//
//  Created by SONG on 10/6/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import InputIDSceneAPI
import InputIDSceneEntity

protocol InputIDDisplayLogic: AnyObject {
  func displaySomething(viewModel: InputID.Something.ViewModel)
}

class InputIDViewController: UIViewController, InputIDViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: InputIDBusinessLogic?
  var router: (InputIDRoutingLogic & InputIDDataPassing)?
  
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

extension InputIDViewController: InputIDDisplayLogic {
  func displaySomething(viewModel: InputID.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension InputIDViewController {
  func doSomething() {
    let request = InputID.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
