//
//  EditToDoViewController.swift
//  ToDo-Garden
//
//  Created by Wood on 6/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditToDoSceneAPI
import EditToDoSceneEntity
import TDUtility
import ToDoGardenUIComponent

protocol EditToDoDisplayLogic: AnyObject {
  func displaySomething(viewModel: EditToDo.Something.ViewModel)
}

final class EditToDoViewController: UIViewController, EditToDoViewControllable {
  private(set) var editToDoSegmentedControl: EditToDoSegmentedControl

  @ExecuteOnce private var scrollToEditToDoMode: (() -> Void)?

  // MARK: - VIP Properties
  
  var interactor: EditToDoBusinessLogic?
  var router: (EditToDoRoutingLogic & EditToDoDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.editToDoSegmentedControl = EditToDoSegmentedControl()
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

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.scrollToEditToDoMode = {
      self.editToDoSegmentedControl.editMode = EditToDoSegmentedControl.EditMode.todo
      self.editToDoSegmentedControl.sendActions(for: UIControl.Event.valueChanged)
    }
  }
}

// MARK: Private Functions

extension EditToDoViewController {
  private func setup() {
    self.setupUI()
    self.setupSubviewsLayout()
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
