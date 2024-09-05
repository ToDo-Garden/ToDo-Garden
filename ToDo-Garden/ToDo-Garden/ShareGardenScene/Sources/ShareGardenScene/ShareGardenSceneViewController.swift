//
//  ShareGardenSceneViewController.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ShareGardenSceneAPI
import ShareGardenSceneEntity

protocol ShareGardenSceneDisplayLogic: AnyObject {
}

final class ShareGardenSceneViewController: UIViewController, ShareGardenSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: (ShareGardenSceneBusinessLogic & FriendsGardenStore)?
  var router: (ShareGardenSceneRoutingLogic & ShareGardenSceneDataPassing)?
  
  // MARK: - UI Properties
  
  private let myGardenView: MyGardenView
  private let friendsGardenView: FriendsGardenView
  
  // MARK: - Object lifecycle
  
  init(friendsGardenStore: FriendsGardenStore) {
    self.myGardenView = MyGardenView()
    self.friendsGardenView = FriendsGardenView(friendsGardenStore: friendsGardenStore)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
}

// MARK: - Conform to display logic protocol

extension ShareGardenSceneViewController: ShareGardenSceneDisplayLogic {
}

// MARK: - Request to interactor

extension ShareGardenSceneViewController {
}
