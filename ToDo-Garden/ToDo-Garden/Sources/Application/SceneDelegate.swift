//
//  SceneDelegate.swift
//  ToDo-Garden
//
//  Created by Noah on 1/10/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    self.registerCustomFonts()
    self.setupWindow(with: scene)
  }
}

extension SceneDelegate {
  private func setupWindow(with scene: UIScene) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    NavigationBarUIUpdator.update(with: self.window)
  }
  
  private func registerCustomFonts() {
    PretendardFont.register()
  }
}
