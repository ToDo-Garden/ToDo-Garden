//
//  ShareGardenSceneRouter.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import TDFoundation
import ToDoGardenUIComponent

import MyStatsSceneAPI
import SearchGardenSceneAPI
import ShareGardenSceneAPI

@MainActor
protocol ShareGardenSceneRoutingLogic {
  func routeToInstaShareClient(icon: UIImage)
  func routeToMyStatsScene()
  func routeToSearchGardenScene()
}

@MainActor
protocol ShareGardenSceneDataPassing {
  var dataStore: ShareGardenSceneDataStore? { get }
}

final class ShareGardenSceneRouter: NSObject, ShareGardenSceneDataPassing {
  weak var viewController: ShareGardenSceneViewController?
  var dataStore: ShareGardenSceneDataStore?
  let searchGardenViewController: SearchGardenViewControllable
  private let myStatsSceneBuilder: MyStatsSceneBuildable
  
  init(
    searchGardenSceneBuilder: SearchGardenSceneBuildable,
    myStatsSceneBuilder: MyStatsSceneBuildable
  ) {
    self.searchGardenViewController = searchGardenSceneBuilder.build()
    self.myStatsSceneBuilder = myStatsSceneBuilder
  }
}

// MARK: - Routing

extension ShareGardenSceneRouter: ShareGardenSceneRoutingLogic {
  func routeToSearchGardenScene() {
    self.searchGardenViewController.presentationController?.delegate = self
    self.viewController?.present(self.searchGardenViewController, animated: true)
  }
  
  func routeToInstaShareClient(icon: UIImage) {
    guard let nickname = self.dataStore?.nickname,
      let streakCount = self.dataStore?.streakCount
    else { return }
      
    let instaShareClient = InstaShareClient.live
    do {
      try instaShareClient.story(name: nickname, icon: icon, focusDays: streakCount)
    } catch {
      let alertController = UIAlertController(
        title: "Instagram 설치가 필요해요",
        message: "Instagram 어플리케이션 설치 후 다시 시도해주세요!",
        preferredStyle: .alert
      )
      alertController.addAction(UIAlertAction(title: "OK", style: .default))
      self.viewController?.present(alertController, animated: true)
    }
  }
  
  func routeToMyStatsScene() {
    guard let myGarden = self.dataStore?.pomodoroRecords
    else { return }
    
    let myGardenScenePayload = MyStatsScenePayload(myGarden: myGarden)
    let myStatsScene = self.myStatsSceneBuilder.build(with: myGardenScenePayload)
    self.viewController?.navigationController?.pushViewController(myStatsScene, animated: true)
  }
}

extension ShareGardenSceneRouter {
  struct MyStatsScenePayload: MyStatsScenePayloadable {
    let myGarden: PomodoroRecordCollection
  }
}

extension ShareGardenSceneRouter: UIAdaptivePresentationControllerDelegate {
  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    self.reloadFriendsGardenList()
  }
  
  private func reloadFriendsGardenList() {
    self.viewController?.interactor?.requestFriendsGardenList()
  }
}

