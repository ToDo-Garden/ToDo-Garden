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

protocol HomeSceneDisplayLogic: AnyObject {
}

open class HomeSceneViewController: UIViewController, HomeSceneViewControllable {
  
  // MARK: - View Properties
  private let homeHeaderView: HomeSceneHeaderView
  private let calendarView: CalendarView
  private var todoListView: ToDoListView?
  
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
  }
  
  open func setBottomSheet() {
    let toDoListViewContainer = ToDoListViewContainer()
    self.todoListView = toDoListViewContainer.toDoListView
    let bottomSheet = BottomSheet()
    bottomSheet.usingAutolayout()
    self.view.addSubview(bottomSheet)
    bottomSheet.contentView = self.todoListView
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
}

// MARK: - Confirm display logic protocol

extension HomeSceneViewController: HomeSceneDisplayLogic {
}

// MARK: - Request to interactor

extension HomeSceneViewController {
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let homeSceneViewController = HomeSceneViewController()
  
  return homeSceneViewController
}
#endif
