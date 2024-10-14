//
//  ShareGardenSceneTests.swift
//  ShareGardenScene
//
//  Created by Noah on 10/8/24.
//

import Testing
import UIKit

import ToDoGardenUIComponent

@testable import ShareGardenScene
import ShareGardenSceneAPI
import ShareGardenSceneEntity

@MainActor
final class ShareGardenSceneTests {
  private let window: UIWindow
  private let shareGardenScene: ShareGardenSceneViewController
  private let shareGardenSceneWorkerMock: ShareGardenSceneWorkerMock
  private let interactor: ShareGardenSceneInteractor
  private let presenter: ShareGardenScenePresenter
  
  private let sut: ShareGardenSceneViewControllerStub
  
  init() {
    self.window = UIWindow()
    self.shareGardenSceneWorkerMock = ShareGardenSceneWorkerMock()
    self.interactor = ShareGardenSceneInteractor(shareGardenSceneWorker: self.shareGardenSceneWorkerMock)
    self.shareGardenScene = ShareGardenSceneViewController(friendsGardenStore: self.interactor)
    self.presenter = ShareGardenScenePresenter()
    self.sut = ShareGardenSceneViewControllerStub()
    self.configureUnitTestVIPCycle()
  }
}

extension ShareGardenSceneTests {
  private func configureUnitTestVIPCycle() {
    self.shareGardenScene.interactor = self.interactor
    self.interactor.presenter = self.presenter
    self.presenter.viewController = self.sut
    self.sut.viewController = self.shareGardenScene
  }
  
  private func loadView() {
    self.window.addSubview(self.shareGardenScene.view)
  }
}
