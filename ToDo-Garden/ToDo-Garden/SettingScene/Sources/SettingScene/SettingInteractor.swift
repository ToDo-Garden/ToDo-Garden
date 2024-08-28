//
//  SettingInteractor.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI
import SettingSceneEntity

protocol SettingDataStore {
  // var name: String { get set }
}

protocol SettingBusinessLogic {
}

class SettingInteractor: SettingDataStore {
  // var name: String = ""
  var presenter: SettingPresentationLogic?
  private let someWorker: SettingWorkable
  
  init(someWorker: SettingWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension SettingInteractor: SettingBusinessLogic {
}
