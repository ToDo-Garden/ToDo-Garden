//
//  HomeSceneViewController.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import HomeSceneAPI
import HomeSceneEntity
<<<<<<< HEAD
import SharedEntity
=======
import TDFoundation
>>>>>>> fc930727 (#907: 변경사항 반영)
import TDFoundationExtension
import TDUtility
import ToDoGardenUIComponent

// swiftlint: disable file_length

@MainActor
protocol HomeSceneDisplayLogic: AnyObject {
<<<<<<< HEAD
  func displayFetchedToDoList(fetchedData: [String: [SharedEntity.TodoListGroup]])
  func displayDailyToDoList(snapshot: ToDoListView.Snapshot)
  func displayCreateToDo(newToDo: SharedEntity.TodoBatchItem)
=======
  func displayFetchedToDoList(fetchedData: [String: [TodoListGroup]])
  func displayDailyToDoList(snapshot: ToDoListView.Snapshot)
  func displayCreateToDo(newToDo: TodoBatchItem)
>>>>>>> fc930727 (#907: 변경사항 반영)
  func displayDeleteToDo(groupID: UUID, deletedToDo: ToDoListView.ToDoItem)
  func displayErrorToast(error: Error)
  func routeToEditToDoScene()
}

@MainActor
open class HomeSceneViewController: UIViewController, HomeSceneViewControllable {
  
  // MARK: - View Properties
  private let homeHeaderView: HomeSceneHeaderView
  private let calendarView: CalendarView
  private var todoListView: ToDoListView?
  private let bottomSheet: BottomSheet = BottomSheet()
  private let loadingIndicator: AnimationImageView = AnimationImageView(jsonURL: .loadingIndicatorURL)
  
  // MARK: - VIP Properties
  
  var interactor: (any HomeSceneBusinessLogic)?
  var router: (any (HomeSceneRoutingLogic & HomeSceneDataPassing))?
  
  // MARK: - Properties
  
  // MARK: - Object lifecycle
  
  public init() {
    self.homeHeaderView = HomeSceneHeaderView()
    self.calendarView = CalendarView(model: CalendarView.Model.primary)
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.white
    self.registerBackgroundTransitionObserver()
  }
  
  deinit {
    self.unregisterBackgroundTransition()
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  open override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    Task {
      await self.interactor?.writeBatchItemsToGRDB()
      await self.interactor?.requestBatchUpdateToServer()
    }
  }
  
  open override func viewIsAppearing(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    self.fetchToDoList()
  }
  
  open func setBottomSheet() {
    let toDoListViewContainer = ToDoListViewContainer()
    self.todoListView = toDoListViewContainer.toDoListView
    self.todoListView?.buttonActionDelegate = self
    self.todoListView?.cellUpdatingDelegate = self
    self.bottomSheet.usingAutolayout()
    self.view.addSubview(self.bottomSheet)
    self.bottomSheet.contentView = self.todoListView
  }
  
  open func setLoadingIndicator() {
    self.loadingIndicator.isHidden = true
    self.loadingIndicator.pauseAnimation()
    self.view.addSubview(self.loadingIndicator)
    self.loadingIndicator.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.loadingIndicator.centerXAnchor.constraint(equalTo: self.bottomSheet.centerXAnchor),
        self.loadingIndicator.centerYAnchor.constraint(equalTo: self.bottomSheet.centerYAnchor, constant: -20)
      ]
    )
  }
  
  open func setUserInteractionDisable() {
    self.calendarView.isUserInteractionEnabled = false
    self.homeHeaderView.isUserInteractionEnabled = false
  }
}

extension HomeSceneViewController {
  private func setupViews() {
    self.setHomeHeaderView()
    self.setCalendarView()
    self.setBottomSheet()
    self.setManageGroupButtonTapped()
    self.setLoadingIndicator()
  }
  
  private func setHomeHeaderView() {
    self.view.addSubview(self.homeHeaderView)
    
    self.homeHeaderView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.homeHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        self.homeHeaderView.leadingAnchor.constraint(
          equalTo: self.view.leadingAnchor,
          constant: Constant.HeaderView.leadingMargin
        ),
        self.homeHeaderView.trailingAnchor.constraint(
          equalTo: self.view.trailingAnchor,
          constant: -Constant.HeaderView.trailingMargin
        )
      ]
    )
  }
  
  private func setCalendarView() {
    self.calendarView.dateSelectionDelegate = self
    self.view.addSubview(self.calendarView)
    self.calendarView.highlightToday()
    self.calendarView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.calendarView.topAnchor.constraint(
          equalTo: self.homeHeaderView.bottomAnchor,
          constant: Constant.CalendarView.topMargin
        ),
        self.calendarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.calendarView.leadingAnchor.constraint(
          equalTo: self.view.leadingAnchor,
          constant: Constant.CalendarView.commonHorizontalMargin
        ),
        self.calendarView.trailingAnchor.constraint(
          equalTo: self.view.trailingAnchor,
          constant: -Constant.CalendarView.commonHorizontalMargin
        )
      ]
    )
  }
  
  private func setManageGroupButtonTapped() {
    self.homeHeaderView.manageGroupButtonTapped = UIAction(handler: { [weak self] _ in
      self?.router?.routeToManageGroupScene()
    })
  }
}

// MARK: - Request to interactor
extension HomeSceneViewController {
  private func fetchToDoList() {
    guard let interactor = self.interactor else { return }
    
    let targetMonth = self.calendarView.getCurrentMonth().toYYYYMMDDStringFromYYYYMM()
    self.hideToDoList()
    self.loadingIndicator.isHidden = false
    self.loadingIndicator.startAnimation()
    Task {
      await interactor.requestBatchUpdateToServer()
      await interactor.fetchToDoList(request: HomeScene.FetchToDoList.Request(dateString: targetMonth))
    }
  }
}

// MARK: - Confirm display logic protocol

extension HomeSceneViewController: HomeSceneDisplayLogic {
<<<<<<< HEAD
  func displayFetchedToDoList(fetchedData: [String: [SharedEntity.TodoListGroup]]) {
    self.hideToDoList()
=======
  func displayFetchedToDoList(fetchedData: [String: [TodoListGroup]]) {
>>>>>>> fc930727 (#907: 변경사항 반영)
    Task {
      let date = self.calendarView.getSelectedDate() ?? Date.now
      await self.interactor?.setMonthlyData(fetchedData)
      await self.interactor?.loadDailyToDoList(targetDate: date.description)
    }
  }
  
  func displayDailyToDoList(snapshot: ToDoListView.Snapshot) {
    self.loadingIndicator.isHidden = true
    self.loadingIndicator.pauseAnimation()
    for section in snapshot.sectionIdentifiers {
      self.todoListView?.updateHeaderUIAfterUpdatingToDo(section: section)
    }
    self.todoListView?.applyWithReloadData(
      snapshot,
      completion: { [weak self] in
        self?.showToDoList()
      }
    )
  }
  
<<<<<<< HEAD
  func displayCreateToDo(newToDo: SharedEntity.TodoBatchItem) {
=======
  func displayCreateToDo(newToDo: TodoBatchItem) {
>>>>>>> fc930727 (#907: 변경사항 반영)
    guard var snapshot = self.todoListView?.getSnapShot(),
      let newToDoUUID = UUID(uuidString: newToDo.localId),
      let newToDoGroupUUID = UUID(uuidString: newToDo.groupId),
      let section = snapshot.sectionIdentifiers.first(
        where: { $0.id == newToDoGroupUUID }
      ) else { return }
 
    let item = ToDoListView.ToDoItem(
      id: newToDoUUID,
      toDoUIModel: ToDoListView.ToDoUIModel(
        text: newToDo.name,
        foregroundColor: section.getColor(),
        isSelected: false,
        hasAlert: false
      )
    )
    
    snapshot.appendItems([item], toSection: section)
    section.appendToDoItems(item)
    self.todoListView?.apply(snapshot)
  }
  
  func displayDeleteToDo(groupID: UUID, deletedToDo: ToDoListView.ToDoItem) {
    guard var snapshot = self.todoListView?.getSnapShot(),
      let section = snapshot.sectionIdentifiers.first(
        where: { $0.id == groupID }
      ) else { return }

    if let deletedIndex = section.getToDoItems().firstIndex(
      where: { $0.id == deletedToDo.id }
    ) {
      section.removeToDoItems(at: deletedIndex)
    }

    snapshot.deleteItems([deletedToDo])
    self.todoListView?.apply(snapshot)
    self.todoListView?.updateHeaderUIAfterUpdatingToDo(section: section)
  }
  
  func displayErrorToast(error: any Error) {
    self.loadingIndicator.isHidden = true
    self.loadingIndicator.pauseAnimation()
    self.showToast(message: error.localizedDescription)
  }

  func routeToEditToDoScene() {
    self.router?.routeToEditToDoScene()
  }
}

// MARK: - Animation
extension HomeSceneViewController {
  func showToDoList() {
    self.todoListView?.isHidden = false
    UIView.animate(withDuration: 0.5) {
      self.todoListView?.alpha = 1
    }
  }
  
  func hideToDoList() {
    UIView.animate(withDuration: 0.5) {
      self.todoListView?.alpha = 0.0
      self.todoListView?.isHidden = true
    }
  }
}

// MARK: - Update Cell
extension HomeSceneViewController: ToDoListViewCellUpdatingDelegate {
  public func updateSelection(
    isSelected: Bool,
    todo: ToDoGardenUIComponent.ToDoListView.ToDoItem,
    at indexPath: IndexPath
  ) {
    guard let targetDate = self.calendarView.getSelectedDate() else { return }
    
    self.interactor?.updateSelection(isSelected: isSelected, indexPath: indexPath, date: targetDate)
  }
  
  public func updateText(text: String, todo: ToDoGardenUIComponent.ToDoListView.ToDoItem, at indexPath: IndexPath) {
    guard let targetDate = self.calendarView.getSelectedDate() else { return }
    
    self.interactor?.updateText(text: text, indexPath: indexPath, date: targetDate)
  }
}

// MARK: - Calendar Actions
extension HomeSceneViewController: CalendarViewDateSelectionDelegate {
  public func didSelectDate(_ date: Date) {
    self.hideToDoList()
    Task {
      await self.interactor?.loadDailyToDoList(targetDate: date.description)
    }
  }

  public func didChangeMonth() {
    Task {
      await self.interactor?.writeBatchItemsToGRDB()
      await self.interactor?.requestBatchUpdateToServer()
      self.fetchToDoList()
    }
  }
}

// MARK: - ToDoList Button Actions
extension HomeSceneViewController: ToDoListButtonActionDelegate {
  public func didEditButtonTapped(
    group: ToDoListView.ToDoSection,
    todo: ToDoListView.ToDoItem
  ) {
    Task {
      guard let selectedDate = self.calendarView.getSelectedDate() else { return }
      let request = HomeScene.PrepareDataForEditToDoScene.Request(
        todoId: todo.id,
        selectedDate: selectedDate,
        groupId: group.id
      )

      self.interactor?.prepareDataForEditTodoScene(request: request)
    }
  }

  public func didDeleteButtonTapped(
    group: ToDoListView.ToDoSection,
    todo: ToDoListView.ToDoItem
  ) {
    Task {
      guard let selectedDate = self.calendarView.getSelectedDate() else { return }
      
      await self.interactor?.deleteToDo(group: group, todo: todo, date: selectedDate)
    }
  }
  
  public func didCreateToDoButtonTapped(group: ToDoListView.ToDoSection) {
    Task {
      guard let selectedDate = self.calendarView.getSelectedDate() else { return }
  
      await self.interactor?.createToDo(group: group, date: selectedDate)
    }
  }
  
  public func didTimerButtonTapped(group: ToDoListView.ToDoSection) {
    self.router?.routeToTimerScene(groupId: group.id.uuidString, groupName: group.getGroupTitle())
  }
}

// MARK: - For Guide Scene
extension HomeSceneViewController {
  public func setForHomeGuide(isToDoItemVisible: Bool = false) {
    self.navigationController?.navigationBar.isHidden = true
    var snapshotForGuide = ToDoListView.Snapshot()
    let color = UIColor.toDoGardenYellow
    let groupForGuide = ToDoListView.ToDoSection(
      headerUIModel: .init(progressColor: color, progressRate: 0.5, groupTitle: "그룹1"),
      toDoItems: [
        ToDoListView.ToDoItem(
          toDoUIModel: .init(text: "오늘의 투두", foregroundColor: color, isSelected: true)
        )
      ]
    )
    
    if isToDoItemVisible == false {
      snapshotForGuide.appendSections([groupForGuide])
    } else {
      snapshotForGuide.appendSections([groupForGuide])
      snapshotForGuide.sectionIdentifiers.forEach { section in
        snapshotForGuide.appendItems(section.getToDoItems(), toSection: section)
      }
    }
    self.todoListView?.apply(snapshotForGuide)
  }
  
  public func setForEditToDoGuide(swipedCell: UIView) {
    self.navigationController?.navigationBar.isHidden = true
    
    guard let contentView = self.bottomSheet.contentView else { return }
    
    contentView.addSubview(swipedCell)
    swipedCell.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        swipedCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -9),
        swipedCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
        swipedCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
        swipedCell.heightAnchor.constraint(equalToConstant: 80)
      ]
    )
  }
  
  public func getToDoListGroup() -> UIView {
    guard let headerView = self.todoListView?.getToDoListGroup() else {
      return UIView()
    }
    return headerView
  }
  
  public func getToDoListToDo() -> UIView {
    guard let cell = self.todoListView?.getToDoListToDo() else { return UIView()}
    return cell
  }
  
  public func getSwipedCell() -> UIView {
    return self.bottomSheet.contentView?.subviews.last ?? UIView()
  }
}

extension HomeSceneViewController: @preconcurrency TransitionHandlable {
  public func handleBackgroundTransition() {
    Task {
      await self.interactor?.writeBatchItemsToGRDB()
      await self.interactor?.requestBatchUpdateToServer()
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let homeSceneViewController = HomeSceneViewController()
  return homeSceneViewController
}
#endif
// swiftlint: enable file_length
