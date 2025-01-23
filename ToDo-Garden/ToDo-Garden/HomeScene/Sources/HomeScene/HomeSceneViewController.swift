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

final class HomeSceneViewController: UIViewController, HomeSceneViewControllable {
  
  // MARK: - View Properties
  
  private var todoListView: ToDoListView?
  
  // MARK: - VIP Properties
  
  var interactor: (any HomeSceneBusinessLogic)?
  var router: (any (HomeSceneRoutingLogic & HomeSceneDataPassing))?
  
  // MARK: - Properties
  
  @ExecuteOnce private var presentSheetIfNeeded: (() -> Void)?
  
  // MARK: - Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.presentSheetIfNeeded = {
      self.presentSheet()
    }
  }
}

extension HomeSceneViewController {
  private func presentSheet() {
    let toDoListViewContainer = ToDoListViewContainer()
    self.todoListView = toDoListViewContainer.toDoListView
    if let sheet = toDoListViewContainer.sheetPresentationController {
      sheet.detents = [
        UISheetPresentationController.Detent.medium(),
        UISheetPresentationController.Detent.large()
      ]
      sheet.prefersGrabberVisible = true
      sheet.prefersScrollingExpandsWhenScrolledToEdge = false
      sheet.largestUndimmedDetentIdentifier = UISheetPresentationController.Detent.Identifier.medium
    }
    toDoListViewContainer.isModalInPresentation = true
    
    self.present(toDoListViewContainer, animated: true)
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
