//
//  MyStatsViewController.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import MyStatsSceneAPI
import MyStatsSceneEntity

protocol MyStatsDisplayLogic: AnyObject {
  func displaySomething(viewModel: MyStats.Something.ViewModel)
}

class MyStatsViewController: UIViewController, MyStatsViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: MyStatsBusinessLogic?
  var router: (MyStatsRoutingLogic & MyStatsDataPassing)?
  
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

extension MyStatsViewController: MyStatsDisplayLogic {
  func displaySomething(viewModel: MyStats.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension MyStatsViewController {
  func doSomething() {
    let request = MyStats.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
