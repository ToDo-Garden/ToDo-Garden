//
//  EditToDoViewController.swift
//  ToDo-Garden
//
//  Created by Wood on 6/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditToDoSceneAPI
import EditToDoSceneEntity
import SharedEntity
import TDFoundation
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
  func displayRepeatOtherDays()
  func displayChangedRepetition(start: String, end: String)
  func displayChangedAlarm(viewModel: EditToDo.ChangeAlarmActivation.ViewModel)
  func displayFetchedAlarmTime(viewModel: EditToDo.FetchAlarmTime.ViewModel)
  func displayChangedAlarmTime(viewModel: EditToDo.ChangeAlarmTime.ViewModel)
}

final public class EditToDoViewController: UIViewController, EditToDoViewControllable {
  private(set) var editToDoSegmentedControl: EditToDoSegmentedControl
  private(set) var editModeScrollView: UIScrollView
  private(set) var editToDoView: EditToDoView
  private(set) var editToDoScheduleView: EditToDoScheduleView
  private(set) var completeEditButton: ToDoGardenBoxButton

  private let alarmTimeSettingModal = ToDoAlarmTimeSettingModal()

  @ExecuteOnce private var scrollToEditToDoMode: (() -> Void)?

  // MARK: - VIP Properties

  var interactor: EditToDoBusinessLogic?
  var router: (EditToDoRoutingLogic & EditToDoDataPassing)?

  // MARK: - Object lifecycle

  public init() {
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
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.alarmTimeSettingModal.delegate = self
  }

  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.interactor?.prepareSceneData()
  }

  public override func viewDidLayoutSubviews() {
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
    if let name = self.editToDoView.getEditingText(),
    let group = self.editToDoView.getCurrentGroup() {
      self.interactor?.editToDo(name: name, groupId: group.groupId)
      self.router?.routeToHomeScene()
    }
  }

  func didToggleSwitch() {
    self.interactor?.changeAlarmActivation()
  }

  func didSelectAlarmSettingButton() {
    self.interactor?.fetchAlarmTime()
  }

  func didSelectAlarmTime(_ alarmTime: Double) {
    self.interactor?.changeAlarmTime(alarmTime)
  }

  func didSelectOnlyTodayView() {
    self.interactor?.changeRepetition(isOnlyToday: true)
  }

  func didSelectRepeatOtherDaysView() {
    self.interactor?.changeRepetition(isOnlyToday: false)
  }

  func didSelectRepetitionDateButton() {
    let repetitionSelectionModal = ToDoRepetitionSettingModal()
    repetitionSelectionModal.delegate = self
    self.present(repetitionSelectionModal, animated: true)
  }

  func didSelectRepetitionRange(_ startDate: Date, _ endDate: Date) {
    self.interactor?.changeReptitionRange(start: startDate, end: endDate)
  }
}

// MARK: - Confirm display logic protocol

extension EditToDoViewController: EditToDoDisplayLogic {
  func displayFetchedToDo(viewModel: EditToDo.FetchToDo.ViewModel) {
    self.updateEditToDoView(toDo: viewModel.toDo, groups: viewModel.groups)
    self.updateEditToDoScheduleView(toDo: viewModel.toDo, alarmTime: viewModel.alarmTime)
  }

  private func updateEditToDoView(toDo: TodoBatchItem, groups: [TodoListGroup]) {
    self.editToDoView.updateToDoName(toDo.name)
    var order = 0
    let groups = groups.map {
      order += 1
      return EditToDo.DisplayedGroup(
        id: $0.localId,
        name: $0.name,
        color: (try? UIColor().fromHex($0.color)) ?? UIColor.toDoGardenGreenDark,
        orderIdx: order
      )
    }
    var newOrder = 0
    guard let group = groups.first(where: {
      newOrder += 1
      return $0.id == toDo.groupId
    }) else { return }

    self.editToDoView.updateGroup(
      current: EditToDo.DisplayedGroup(
        id: group.id,
        name: group.name,
        color: group.color,
        orderIdx: newOrder
      )
    )
    self.editToDoView.updateGroupList(groups)
  }

  private func updateEditToDoScheduleView(toDo: TodoBatchItem, alarmTime: String) {
    if toDo.isAlarmOn {
      self.editToDoScheduleView.updateToAlarmOn()
    } else {
      self.editToDoScheduleView.updateToAlarmOff()
    }
    self.editToDoScheduleView.updateAlarmTime(alarmTime: alarmTime)
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
    self.router?.routeToHomeScene()
  }

  func displayRepeatOnlyToday() {
    self.editToDoScheduleView.updateToRepeatOnlyToday()
  }

  func displayRepeatOtherDays() {
    self.editToDoScheduleView.updateToRepeatOtherDays()
  }

  func displayChangedRepetition(start: String, end: String) {
    self.editToDoScheduleView.updateToRepeatInRange(startDay: start, endDay: end)
  }

  func displayChangedAlarm(viewModel: EditToDo.ChangeAlarmActivation.ViewModel) {
    if viewModel.isAlarmOn {
      self.editToDoScheduleView.updateToAlarmOn()
    } else {
      self.editToDoScheduleView.updateToAlarmOff()
    }
  }

  func displayFetchedAlarmTime(viewModel: EditToDo.FetchAlarmTime.ViewModel) {
    self.alarmTimeSettingModal.sheetPresentationController?.detents = [.medium()]
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
  public func handleButtonAction(
    _ buttonType: ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType
  ) {
    self.closeAlert()
    switch buttonType {
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.retry:
      self.interactor?.prepareSceneData()
    case ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType.goHome:
      self.router?.routeToHomeScene()
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
  public func scrollViewWillEndDragging(
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
// swiftlint:disable all
extension EditToDoViewController {
  struct EditToDoScenePayload: EditToDoScenePayloadable {
    var toDo: TodoBatchItem
    var groups: [SharedEntity.TodoListGroup]
    var delegate: EditToDoSceneAPI.EditToDoSceneDelegate?
  }

  class SomeViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      let editToDoViewController = EditToDoSceneBuilder().build(
        with: EditToDoViewController.EditToDoScenePayload(
          toDo: TodoBatchItem(
            localId: "sadfasdfsdf", name: "temp", isDone: true,
            createdAt: "1212", isAlarmOn: true, alarmTime: Double(43450),
            isOnlyToday: true, startDay: nil, endDay: nil, groupId: "1111", isDelete: false
          ),
          groups: [
            TodoListGroup(
              localId: "2222", name: "그룹2", color: UIColor.blue.hexStringFromColor(),
              todoList: nil, progressRate: Double(0)
            ),
            TodoListGroup(
              localId: "1111", name: "그룹1", color: UIColor.toDoGardenGreenDark.hexStringFromColor(),
              todoList: nil, progressRate: Double(0.4)
            ),
            TodoListGroup(
              localId: "3333", name: "그룹3", color: UIColor.red.hexStringFromColor(),
              todoList: nil, progressRate: Double(0.1)
            )
          ]
        )
      )
      self.navigationController?.pushViewController(editToDoViewController, animated: true)
    }
  }
}
// swiftlint:enable all

extension EditToDoViewController {
  public func setForGuide(index: Int) {
    switch index {
    case 1:
      self.editToDoSegmentedControl.selectedSegmentIndex = 1
      self.editToDoView.setForGuide()
    case 2:
      self.editToDoSegmentedControl.selectedSegmentIndex = 0
      self.editToDoScheduleView.setForGuide()
    default:
      break
    }
  }

  public func getToDoNameInputView() -> UIView {
    return self.editToDoView.getToDoNameInputView()
  }

  public func getGroupSelectionView() -> UIView {
    return self.editToDoView.getGroupSelectionView()
  }

  public func getSegmentedControl() -> UIView {
    return self.editToDoSegmentedControl
  }

  public func getAlarmTimeView() -> UIView {
    return self.editToDoScheduleView.getAlarmTimeView()
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UINavigationController(rootViewController: EditToDoViewController.SomeViewController())
}
#endif
