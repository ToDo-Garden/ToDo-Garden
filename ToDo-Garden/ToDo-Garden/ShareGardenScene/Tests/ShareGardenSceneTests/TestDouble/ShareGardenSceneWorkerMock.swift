// swiftlint:disable all
//
//  ShareGardenSceneWorkerMock.swift
//  ShareGardenScene
//
//  Created by Noah on 10/8/24.
//

import Foundation

import ToDoGardenUIComponent

import ShareGardenScene
import ShareGardenSceneAPI
import ShareGardenSceneEntity

actor ShareGardenSceneWorkerMock {
  private var isSuccessful: Bool = false
  private var myGarden: ShareGardenScene.MyGarden?
  
  func setMyGarden(_ myGarden: ShareGardenScene.MyGarden) {
    self.myGarden = myGarden
  }

extension ShareGardenSceneWorkerMock {
  private func checkIsSuccessfulTask() throws {
    if self.isSuccessful == false {
      throw NSError(domain: "", code: 999)
    }
  }
}

// swiftlint:enable all
