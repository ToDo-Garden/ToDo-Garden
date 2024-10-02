//
//  EditUserNameScenePresenter.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneEntity

protocol EditUserNameScenePresentationLogic {
  func presentUserName(_ userName: String?)
  func presentUserNameVerification(isValid: Bool)
}

class EditUserNameScenePresenter {
  weak var viewController: EditUserNameSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension EditUserNameScenePresenter: EditUserNameScenePresentationLogic {
  func presentUserName(_ userName: String?) {
    if let userName {
      self.viewController?.displayUserName(userName)
    } else {
      self.viewController?.displayEmptyUserName()
    }
  }

  func presentUserNameVerification(isValid: Bool) {
    
  }
}
