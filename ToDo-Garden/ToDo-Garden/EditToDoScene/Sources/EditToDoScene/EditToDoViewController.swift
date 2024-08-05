//
//  EditToDoViewController.swift
//  ToDo-Garden
//
//  Created by Wood on 6/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditToDoSceneAPI
import EditToDoSceneEntity

protocol EditToDoDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditToDo.Something.ViewModel)
}

class EditToDoViewController: UIViewController, EditToDoViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: EditToDoBusinessLogic?
  var router: (EditToDoRoutingLogic & EditToDoDataPassing)?
  
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
    self.setup()
  }
}

// MARK: Private Functions

extension EditToDoViewController {
  private func setup() {
    self.setupUI()
  }

  private func setupUI() {
    self.title = EditToDoSceneTheme.StringLiteral.EditToDoViewController.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }
}

// MARK: - Confirm display logic protocol

extension EditToDoViewController: EditToDoDisplayLogic {
  func displaySomething(viewModel: EditToDo.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor

extension EditToDoViewController {}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: EditToDoViewController())
}
#endif
