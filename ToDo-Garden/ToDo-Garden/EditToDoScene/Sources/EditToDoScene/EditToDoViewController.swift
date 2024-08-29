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
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant

protocol EditToDoDisplayLogic: AnyObject {
  func displayFetchedToDo(viewModel: EditToDo.FetchToDo.ViewModel)
  func displayDeleteToDoResult(viewModel: EditToDo.DeleteToDo.ViewModel)
  func displayEditToDoResult(viewModel: EditToDo.CompleteEditToDo.ViewModel)
  func displayChangedRepetition(viewModel: EditToDo.ChangeRepetition.ViewModel)
  func displayChangedAlarm(viewModel: EditToDo.ChangeAlarmActivation.ViewModel)
  func displayFetchedAlarmTime(viewModel: EditToDo.FetchAlarmTime.ViewModel)
  func displayChangedAlarmTime(viewModel: EditToDo.ChangeAlarmTime.ViewModel)
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
    self.interactor?.fetchToDo()
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

extension EditToDoViewController: EditToDoScheduleViewDelegate, ToDoAlarmTimeSettingModalDelegate {
  func editToDo() {
    if let toDoNameForEdit = self.editToDoView.getEditingText(),
      let groupForEdit = self.editToDoView.getCurrentGroup() {
      let request = EditToDo.CompleteEditToDo.Request(toDoName: toDoNameForEdit, displayedGroup: groupForEdit)
      self.interactor?.editToDo(request: request)
    }
  }

  func didSelectOnlyTodayView(isOnlyToday: Bool) {
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: isOnlyToday, isEveryday: nil)
    self.interactor?.changeReptition(request: request)
  }

  func didSelectEverydayButton(isSelected: Bool) {
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: false, isEveryday: isSelected)
    self.interactor?.changeReptition(request: request)
  }

  func didToggleSwitch() {
    self.interactor?.changeAlarmActivation()
  }

  func didSelectAlarmSettingButton() {
    self.interactor?.fetchAlarmTime()
  }

  func didSelectAlarmTime(_ alarmTime: Double) {
    let request = EditToDo.ChangeAlarmTime.Request(alarmTime: alarmTime)
    self.interactor?.changeAlarmTime(request: request)
  }
}

// MARK: - Confirm display logic protocol

extension EditToDoViewController: EditToDoDisplayLogic {
  func displayFetchedToDo(viewModel: EditToDo.FetchToDo.ViewModel) {
    switch viewModel.fetchedToDoResult {
    case Result.success(let displayedToDo):
      self.editToDoView.updateToDoName(displayedToDo.toDoName)
      self.editToDoView.updateGroup(current: displayedToDo.group, editableGroupList: displayedToDo.groupList)
      self.updateAlarmState(isAlarmOn: displayedToDo.isAlarmOn)
      self.updateRepetitionViewState(displayedToDo.repetitionViewState)
      if let alarmTime = displayedToDo.alarmTime {
        self.editToDoScheduleView.updateAlarmTime(alarmTime: alarmTime)
      }
    case Result.failure:
      let failToFetchAlert = ToDoGardenAlertController(for: ToDoGardenAlertView.Configuration.failToFetchToDo)
      failToFetchAlert.delegate = self
      self.showAlert(failToFetchAlert)
    }
  }

  func displayDeleteToDoResult(viewModel: EditToDo.DeleteToDo.ViewModel) {
    switch viewModel.deleteResult {
    case Result.success:
      self.router?.routeToToDoListScene()
    case Result.failure(let error):
      self.showErrorAlert(error)
    }
  }

  func displayEditToDoResult(viewModel: EditToDo.CompleteEditToDo.ViewModel) {
    switch viewModel.editResult {
    case Result.success:
      self.router?.routeToToDoListScene()
    case Result.failure(let error):
      self.showErrorAlert(error)
    }
  }

  func displayChangedRepetition(viewModel: EditToDo.ChangeRepetition.ViewModel) {
    self.updateRepetitionViewState(viewModel.editToDoRepetitionViewState)
  }

  func displayChangedAlarm(viewModel: EditToDo.ChangeAlarmActivation.ViewModel) {
    self.updateAlarmState(isAlarmOn: viewModel.isAlarmOn)
  }

  func displayFetchedAlarmTime(viewModel: EditToDo.FetchAlarmTime.ViewModel) {
    let alarmTimeSettingModal = ToDoAlarmTimeSettingModal()
    alarmTimeSettingModal.delegate = self
    let hour = viewModel.hour
    let minute = viewModel.minute
    alarmTimeSettingModal.updateInitialAlarmTime(hour: hour, minute: minute)
    self.present(alarmTimeSettingModal, animated: true)
  }

  func displayChangedAlarmTime(viewModel: EditToDo.ChangeAlarmTime.ViewModel) {
    let alarmTimeString = viewModel.alarmTimeString
    self.editToDoScheduleView.updateAlarmTime(alarmTime: alarmTimeString)
  }
}

// MARK: ToDoGardenAlertController Delegate Functions

extension EditToDoViewController: ToDoGardenAlertControllerDelegate {
  func handleButtonAction(
    _ buttonType: ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType
  ) {
    self.closeAlert()
    switch buttonType {
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.retry:
      self.interactor?.fetchToDo()
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.goHome:
      self.router?.routeToToDoListScene()
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.delete:
      self.interactor?.deleteToDo()
    default:
      break
    }
  }

  private func showErrorAlert(_ error: Error) {
    let errorMessage = (error as CustomStringConvertible).description
    let errorOccurredAlert = ToDoGardenAlertController(
      for: ToDoGardenAlertView.Configuration.errorOccurred(errorMessage)
    )
    errorOccurredAlert.delegate = self
    self.showAlert(errorOccurredAlert)
  }
}

// MARK: Subviews Delegate Functions

extension EditToDoViewController: EditToDoView.EditToDoViewDelegate {
  func didSelectDeleteToDoButton() {
    let deleteToDoAlert = ToDoGardenAlertController(for: ToDoGardenAlertView.Configuration.askToDeleteToDo)
    deleteToDoAlert.delegate = self
    self.showAlert(deleteToDoAlert)
  }
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
  private func updateAlarmState(isAlarmOn: Bool) {
    if isAlarmOn {
      self.editToDoScheduleView.updateToAlarmOn()
    } else {
      self.editToDoScheduleView.updateToAlarmOff()
    }
  }

  private func updateRepetitionViewState(_ state: EditToDo.EditToDoRepetitionViewState) {
    switch state {
    case EditToDo.EditToDoRepetitionViewState.repeatOnlyToday:
      self.editToDoScheduleView.updateToRepeatOnlyToday()
    case EditToDo.EditToDoRepetitionViewState.repeatEveryday:
      self.editToDoScheduleView.updateToRepeatEveryday()
    case EditToDo.EditToDoRepetitionViewState.repeatInRange:
      self.editToDoScheduleView.updateToRepeatInRange()
    }
  }
}

extension EditToDoViewController {
  struct EditToDoScenePayload: EditToDoScenePayloadable {
    var toDoId: Int
  }

  class SomeViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      let editToDoViewController = EditToDoSceneBuilder(
        dependency: EditToDoSceneBuilder.Dependency(
          toDoWorker: ToDoWorker(),
          groupWorker: GroupWorker()
        )
      ).build(with: EditToDoViewController.EditToDoScenePayload(toDoId: 0))
      self.navigationController?.pushViewController(editToDoViewController, animated: true)
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: EditToDoViewController.SomeViewController())
}
#endif
