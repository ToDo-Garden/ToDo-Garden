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
  func displayFetchedToDo(viewModel: EditToDo.FetchToDo.ViewModel)
}

final class EditToDoViewController: UIViewController, EditToDoViewControllable {
  private(set) var editToDoSegmentedControl: EditToDoSegmentedControl
  private(set) var editModeScrollView: UIScrollView
  private(set) var editToDoView: EditToDoView
  private(set) var editToDoScheduleView: EditToDoScheduleView
  private(set) var completeEditButton: UIButton

  @ExecuteOnce private var scrollToEditToDoMode: (() -> Void)?

  // MARK: - VIP Properties
  
  var interactor: EditToDoBusinessLogic?
  var router: (EditToDoRoutingLogic & EditToDoDataPassing)?
  
  // MARK: - Object lifecycle
  
  init() {
    self.editToDoSegmentedControl = EditToDoSegmentedControl()
    self.editModeScrollView = UIScrollView()
    self.editToDoView = EditToDoView()
    self.editToDoScheduleView = EditToDoScheduleView()
    self.completeEditButton = ToDoGardenBoxButton(
      title: EditToDoSceneTheme.StringLiteral.CompleteEditingButton.title,
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.fetchToDo()
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

// MARK: - Request to interactor

extension EditToDoViewController {
  private func fetchToDo() {
    let request = EditToDo.FetchToDo.Request()
    self.interactor?.fetchToDo(request: request)
  }
}

// MARK: - Confirm display logic protocol

extension EditToDoViewController: EditToDoDisplayLogic {
  func displayFetchedToDo(viewModel: EditToDo.FetchToDo.ViewModel) {}
}

// MARK: ScrollView Delegate Functions

extension EditToDoViewController: UIScrollViewDelegate {
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let targetOffset = targetContentOffset.pointee.x
    self.changeSegmentedControlEditMode(by: targetOffset)
  }

  /// 화면을 스크롤 했을 때, 수정모드에 맞게 SegmentedControl의 Index를 변경하는 메서드입니다.
  private func changeSegmentedControlEditMode(by targetOffset: CGFloat) {
    let scrollViewWidth = self.editModeScrollView.frame.width
    let targetOffset = targetOffset
    let editModeType = EditToDoSegmentedControl.EditMode.self
    let editMode = targetOffset == scrollViewWidth ? editModeType.todo : editModeType.notification
    self.editToDoSegmentedControl.selectedSegmentIndex = editMode.rawValue
  }
}

// MARK: Private Functions

extension EditToDoViewController {
  private func setup() {
    self.setupUI()
    self.setupEditModeScrollView()
    self.setupEditModeSegmentedControlAction()
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
    self.editModeScrollView.delegate = self
    self.editModeScrollView.bounces = false
  }

  private func setupEditModeSegmentedControlAction() {
    let segmentedControlAction = UIAction { _ in
      if let editMode = self.editToDoSegmentedControl.editMode {
        self.changeEditMode(by: editMode)
      }
    }

    self.editToDoSegmentedControl.addAction(segmentedControlAction, for: UIControl.Event.valueChanged)
  }

  private func changeEditMode(by editMode: EditToDoSegmentedControl.EditMode) {
    let editModeType = EditToDoSegmentedControl.EditMode.self
    let pointX = editMode == editModeType.notification ? 0 : self.editModeScrollView.frame.width
    let contentOffset = CGPoint(x: pointX, y: 0)
    self.editModeScrollView.setContentOffset(contentOffset, animated: true)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: EditToDoViewController())
}
#endif
