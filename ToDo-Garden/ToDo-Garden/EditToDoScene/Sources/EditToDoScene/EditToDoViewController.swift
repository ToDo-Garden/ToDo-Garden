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
  func displayFetchedGroupList(_ groupList: [EditToDo.DisplayedGroup])
  func displayDismiss()
  func showErrorAlert(_ type: EditToDo.ErrorType)

  func displayRepeatOnlyToday()
  func displayChangedRepetition(viewModel: EditToDo.ChangeRepetitionRange.ViewModel)
  func displayChangedAlarm(viewModel: EditToDo.ChangeAlarmActivation.ViewModel)
  func displayFetchedAlarmTime(viewModel: EditToDo.FetchAlarmTime.ViewModel)
  func displayChangedAlarmTime(viewModel: EditToDo.ChangeAlarmTime.ViewModel)
}

final class EditToDoViewController: UIViewController, EditToDoViewControllable {
  private(set) var editToDoSegmentedControl: EditToDoSegmentedControl
  private(set) var editModeScrollView: UIScrollView
  private(set) var editToDoView: EditToDoView
  private(set) var editToDoScheduleView: EditToDoScheduleView
  private(set) var completeEditButton: ToDoGardenBoxButton

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

  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.interactor?.prepareSceneData()
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

extension EditToDoViewController: ToDoAlarmTimeSettingModalDelegate, ToDoRepetitionSettingModalDelegate {}

extension EditToDoViewController: EditToDoScheduleViewDelegate {
  func editToDo() {
    if let toDoNameForEdit = self.editToDoView.getEditingText(),
      let groupForEdit = self.editToDoView.getCurrentGroup() {
      let request = EditToDo.CompleteEditToDo.Request(
        toDoName: toDoNameForEdit,
        displayedGroup: EditToDo.DisplayedGroup(
          id: groupForEdit.groupId,
          name: groupForEdit.groupName,
          color: groupForEdit.groupColor,
          orderIdx: 0
        )
      )
      self.interactor?.editToDo(request: request)
    }
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

  func didSelectOnlyTodayView(isOnlyToday: Bool) {
    self.interactor?.changeRepetition(isOnlyToday: isOnlyToday)
  }

  func didSelectRepetitionDateButton() {
    let repetitionSelectionModal = ToDoRepetitionSettingModal()
    repetitionSelectionModal.delegate = self
    self.present(repetitionSelectionModal, animated: true)
  }

  func didSelectRepetitionRange(_ startDate: Date, _ endDate: Date) {
    let request = EditToDo.ChangeRepetitionRange.Request(startDate: startDate, endDate: endDate)
    self.interactor?.changeReptitionRange(request: request)
  }
}

// MARK: - Confirm display logic protocol

extension EditToDoViewController: EditToDoDisplayLogic {
  func displayFetchedToDo(viewModel: EditToDo.FetchToDo.ViewModel) {
    let toDo = viewModel.toDo
    self.editToDoView.updateToDoName(toDo.toDoName)
    self.editToDoView.updateGroup(current: toDo.group)
    if toDo.isAlarmOn {
      self.editToDoScheduleView.updateToAlarmOn()
    } else {
      self.editToDoScheduleView.updateToAlarmOff()
    }
    if let alarmTime = toDo.alarmTime {
      self.editToDoScheduleView.updateAlarmTime(alarmTime: alarmTime)
    }
    self.editToDoView.updateToDoName(toDo.toDoName)
    if toDo.isOnlyToday {
      self.editToDoScheduleView.updateToRepeatOnlyToday()
    } else {
      if let startDay = toDo.startDay, let endDay = toDo.endDay {
        self.editToDoScheduleView.updateToRepeatInRange(startDay: startDay, endDay: endDay)
      }
    }
  }

  func displayFetchedGroupList(_ groupList: [EditToDo.DisplayedGroup]) {
    self.editToDoView.updateGroupList(groupList)
  }

  func displayDismiss() {
    self.router?.routeToToDoListScene()
  }

  func displayRepeatOnlyToday() {
    self.editToDoScheduleView.updateToRepeatOnlyToday()
  }

  func displayChangedRepetition(viewModel: EditToDo.ChangeRepetitionRange.ViewModel) {
    let startDay = viewModel.startDay
    let endDay = viewModel.endDay
    self.editToDoScheduleView.updateToRepeatInRange(startDay: startDay, endDay: endDay)
  }

  func displayChangedAlarm(viewModel: EditToDo.ChangeAlarmActivation.ViewModel) {
    if viewModel.isAlarmOn {
      self.editToDoScheduleView.updateToAlarmOn()
    } else {
      self.editToDoScheduleView.updateToAlarmOff()
    }
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
      self.interactor?.prepareSceneData()
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.goHome:
      self.router?.routeToToDoListScene()
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.delete:
      self.interactor?.deleteToDo()
    default:
      break
    }
  }

  func showErrorAlert(_ type: EditToDo.ErrorType) {
    switch type {
    case .temporary, .network:
      let errorMessage = type.rawValue
      let errorOccurredAlert = ToDoGardenAlertController(
        for: ToDoGardenAlertView.Configuration.errorOccurred(errorMessage)
      )
      errorOccurredAlert.delegate = self
      self.showAlert(errorOccurredAlert)
    case .failToFetch:
      let failToFetchAlert = ToDoGardenAlertController(for: ToDoGardenAlertView.Configuration.failToFetchToDo)
      failToFetchAlert.delegate = self
      self.showAlert(failToFetchAlert)
    }
  }
}

// MARK: Subviews Delegate Functions

extension EditToDoViewController: EditToDoView.EditToDoViewDelegate {
  func didEditToDoName(_ name: String?) {
    let isEditedNameEmpty = name?.isEmpty ?? true
    if isEditedNameEmpty {
      self.completeEditButton.disable()
    } else {
      self.completeEditButton.enable()
    }
  }

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

import HTTPClient

extension EditToDoViewController {
  struct EditToDoScenePayload: EditToDoScenePayloadable {
    var toDoId: UUID
  }

  class SomeViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      let editToDoViewController = EditToDoSceneBuilder(
        dependency: EditToDoSceneBuilder.Dependency(
          editToDoWorker: EditToDoWorker(httpClient: HTTPClient.live)
        )
      ).build(with: EditToDoViewController.EditToDoScenePayload(toDoId: UUID()))
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
