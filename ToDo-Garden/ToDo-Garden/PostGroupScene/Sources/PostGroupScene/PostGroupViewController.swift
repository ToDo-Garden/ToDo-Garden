//
//  PostGroupViewController.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import PostGroupSceneAPI
import PostGroupSceneEntity

protocol PostGroupDisplayLogic: AnyObject {
  func displaySomething(viewModel: PostGroup.Something.ViewModel)
}

class PostGroupViewController: UIViewController, PostGroupViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: PostGroupBusinessLogic?
  var router: (PostGroupRoutingLogic & PostGroupDataPassing)?
  
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

extension PostGroupViewController: PostGroupDisplayLogic {
  func displaySomething(viewModel: PostGroup.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension PostGroupViewController {
  func doSomething() {
    let request = PostGroup.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
