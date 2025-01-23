//
//  HomeSceneViewController.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import HomeSceneAPI

protocol HomeSceneDisplayLogic: AnyObject {
}

final class HomeSceneViewController: UIViewController, HomeSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: (any HomeSceneBusinessLogic)?
  var router: (any (HomeSceneRoutingLogic & HomeSceneDataPassing))?
  
  // MARK: - Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
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
