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
  private var friendsGardenList: [ShareGardenScene.FriendsGarden]?
  
  func setMyGarden(_ myGarden: ShareGardenScene.MyGarden) {
    self.myGarden = myGarden
  }
  
  func setFriendsGardenList(_ friendsGardenList: [ShareGardenScene.FriendsGarden]) {
    self.friendsGardenList = friendsGardenList
  }
  
  func setIsSuccessful(_ isSuccessful: Bool) {
    self.isSuccessful = isSuccessful
  }
}

extension ShareGardenSceneWorkerMock: ShareGardenSceneWorkable {
  func requestMyGarden() async throws -> ShareGardenScene.MyGarden {
    try self.checkIsSuccessfulTask()
    
    return self.myGarden!
  }
  
  func requestFriendsGardenList() async throws -> [ShareGardenScene.FriendsGarden] {
    try self.checkIsSuccessfulTask()
    
    return self.friendsGardenList!
  }
  
  func delete(by id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID) async throws {
    try self.checkIsSuccessfulTask()
  }
}

extension ShareGardenSceneWorkerMock {
  private func checkIsSuccessfulTask() throws {
    if self.isSuccessful == false {
      throw NSError(domain: "", code: 999)
    }
  }
}

// swiftlint:enable all
