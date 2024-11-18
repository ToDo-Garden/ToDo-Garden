//
//  SearchGardenViewController.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

protocol SearchGardenDisplayLogic: AnyObject {
  func displaySomething(viewModel: SearchGarden.Something.ViewModel)
}

class SearchGardenViewController: UIViewController, SearchGardenViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: SearchGardenBusinessLogic?
  var router: (SearchGardenRoutingLogic & SearchGardenDataPassing)?
  
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

extension SearchGardenViewController: SearchGardenDisplayLogic {
  func displaySomething(viewModel: SearchGarden.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension SearchGardenViewController {
  func doSomething() {
    let request = SearchGarden.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
