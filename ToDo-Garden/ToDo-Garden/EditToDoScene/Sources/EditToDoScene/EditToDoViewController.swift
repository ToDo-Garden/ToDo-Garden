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
  private(set) var editModeScrollView: UIScrollView

  @ExecuteOnce private var scrollToEditToDoMode: (() -> Void)?

  // MARK: - VIP Properties
  
  var interactor: EditToDoBusinessLogic?
  var router: (EditToDoRoutingLogic & EditToDoDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.editToDoSegmentedControl = EditToDoSegmentedControl()
    self.editModeScrollView = UIScrollView()
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
    // MARK: 투두 수정화면 진입시 투두 수정 모드로 변경합니다.
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
    self.setupEditModeScrollView()
    self.setupSubviewsLayout()
  }

  private func setupUI() {
    self.title = EditToDoSceneTheme.StringLiteral.EditToDoViewController.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupEditModeScrollView() {
    self.editModeScrollView.showsVerticalScrollIndicator = false
    self.editModeScrollView.showsHorizontalScrollIndicator = false
    self.editModeScrollView.isPagingEnabled = true
    self.editModeScrollView.bounces = false
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
