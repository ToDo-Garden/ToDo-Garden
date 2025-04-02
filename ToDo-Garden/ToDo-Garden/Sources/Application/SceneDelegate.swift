//
//  SceneDelegate.swift
//  ToDo-Garden
//
//  Created by Noah on 1/10/24.
//

import UIKit

import AppCore
import ToDoGardenUIComponent
import ToDoGardenUIResource

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var appCore = AppCore(dependency: AppCore.Dependency.live)
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    self.setupWindow(with: scene)
    self.appCore.getStarted()
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    self.appCore.didBecomeActive()
  }
}

extension SceneDelegate {
  private func setupWindow(with scene: UIScene) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    window?.rootViewController = self.appCore.dependency.router.navigationController
    window?.makeKeyAndVisible()
  }
}
