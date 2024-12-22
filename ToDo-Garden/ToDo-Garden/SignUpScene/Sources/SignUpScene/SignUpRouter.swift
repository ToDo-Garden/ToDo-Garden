//
//  SignUpRouter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneAPI

protocol SignUpRoutingLogic {
  func exitSignUpScene()
}

protocol SignUpDataPassing {
  var dataStore: SignUpDataStore? { get }
}

class SignUpRouter: SignUpDataPassing {
  weak var viewController: SignUpViewController?
  var dataStore: SignUpDataStore?
  
  init() { }
}

// MARK: - Routing

extension SignUpRouter: SignUpRoutingLogic {
  func exitSignUpScene() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
}
