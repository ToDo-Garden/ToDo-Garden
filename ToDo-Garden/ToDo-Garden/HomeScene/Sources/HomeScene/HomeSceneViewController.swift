//
//  HomeSceneViewController.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import TDUtility
import ToDoGardenUIComponent

import HomeSceneAPI
import HomeSceneEntity

@MainActor
protocol HomeSceneDisplayLogic: AnyObject {
  func displayFetchedToDoList(snapshot: ToDoListView.Snapshot)
  func displayCreateToDo()
  func displayDeleteToDo() 
}

@MainActor
open class HomeSceneViewController: UIViewController, HomeSceneViewControllable {
  
  // MARK: - View Properties
  private let homeHeaderView: HomeSceneHeaderView
  private let calendarView: CalendarView
  private var todoListView: ToDoListView?
  private let bottomSheet: BottomSheet = BottomSheet()
  
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
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  open override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.fetchToDoList()
  }
  
  open override func viewIsAppearing(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  open func setBottomSheet() {
    let toDoListViewContainer = ToDoListViewContainer()
    self.todoListView = toDoListViewContainer.toDoListView
    self.todoListView?.buttonActionDelegate = self
    self.bottomSheet.usingAutolayout()
    self.view.addSubview(self.bottomSheet)
    self.bottomSheet.contentView = self.todoListView
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
    self.view.addSubview(self.calendarView)
    
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

extension HomeSceneViewController {
  private func fetchToDoList() {
    Task {
      await self.interactor?.fetchToDoList()
    }
  }
}

// MARK: - Confirm display logic protocol

extension HomeSceneViewController: HomeSceneDisplayLogic {
  func displayFetchedToDoList(snapshot: ToDoListView.Snapshot) {
    self.todoListView?.apply(snapshot)
  }
  
  func displayCreateToDo() {
    debugPrint("CREATE TODO")
  }
  
  func displayDeleteToDo() {
    debugPrint("DELETE TODO")
  }
}

// MARK: - Request to interactor

extension HomeSceneViewController {
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
        snapshotForGuide.appendItems(section.toDoItems, toSection: section)
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
// MARK: - ToDoList Button Actions

extension HomeSceneViewController: ToDoListButtonActionDelegate {
  public func didEditButtonTapped(
    group: ToDoListView.ToDoSection,
    todo: ToDoListView.ToDoItem
  ) {
    self.router?.routeToEditToDoScene(toDoId: todo.id)
  }
  
  public func didDeleteButtonTapped(
    group: ToDoListView.ToDoSection,
    todo: ToDoListView.ToDoItem
  ) {
    Task {
      await self.interactor?.deleteToDo()
    }
  }
  
  public func didCreateToDoButtonTapped(group: ToDoListView.ToDoSection) {
    Task {
      await self.interactor?.createToDo()
    }
  }
  
  public func didTimerButtonTapped(group: ToDoListView.ToDoSection) {
    self.router?.routeToTimerScene(groupId: group.id.uuidString, groupName: group.getGroupTitle())
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let homeSceneViewController = HomeSceneViewController()
  return homeSceneViewController
}
#endif
