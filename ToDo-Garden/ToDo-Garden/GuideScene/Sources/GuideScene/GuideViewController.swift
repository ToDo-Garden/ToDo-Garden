//
//  GuideViewController.swift
//  GuideScene
//
//  Created by Cloud on 8/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

protocol GuideDisplayLogic: AnyObject {
  func displaySomething(viewModel: Guide.Something.ViewModel)
}

class GuideViewController: UIViewController, GuideViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: GuideBusinessLogic?
  var router: (GuideRoutingLogic & GuideDataPassing)?
  
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

extension GuideViewController: GuideDisplayLogic {
  func displaySomething(viewModel: Guide.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension GuideViewController {
  func doSomething() {
    let request = Guide.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
