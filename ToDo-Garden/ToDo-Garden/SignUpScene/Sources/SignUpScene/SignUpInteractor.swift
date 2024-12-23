//
//  SignUpInteractor.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneAPI
import SignUpSceneEntity

protocol SignUpDataStore {
  var isEventAndPromotionalInformationAgreed: Bool { get }
}

@MainActor
protocol SignUpBusinessLogic {
  func checkStringValidation(request: SignUp.CheckStringValidation.Request)
  func registerUser(request: SignUp.RegisterUser.Request)
}

class SignUpInteractor: SignUpDataStore {
  var isEventAndPromotionalInformationAgreed: Bool = false
  var presenter: SignUpPresentationLogic?
  private let signUpWorker: SignUpWorkable
  private var tasks: [TaskKey: Task<Void, Never>] = [:]
  
  init(signUpWorker: SignUpWorkable) {
    self.signUpWorker = signUpWorker
  }
  
  func cancelTask(for key: TaskKey) {
    self.tasks[key]?.cancel()
    self.tasks[key] = nil
  }
}

// MARK: - Request to worker

extension SignUpInteractor: SignUpBusinessLogic {
  func checkStringValidation(request: SignUp.CheckStringValidation.Request) {
    let state = self.signUpWorker.checkStringValidation(text: request.text, currentPageIndex: request.currentPageIndex)
    
    let response = SignUp.CheckStringValidation.Response(
      validationState: state,
      currentPageIndex: request.currentPageIndex
    )
    
    switch state {
    case SignUp.ValidationState.valid:
      self.presenter?.presentValid(response: response)
    case SignUp.ValidationState.invalid:
      self.presenter?.presentInvalid(response: response)
    case SignUp.ValidationState.empty:
      if request.currentPageIndex == 1 {
        self.presenter?.presentValid(response: response)
      } else {
        self.presenter?.presentInvalid(response: response)
      }
    }
  }
  
  func registerUser(request: SignUp.RegisterUser.Request) {
    self.tasks[TaskKey.registerUser] = Task {
      defer { self.tasks[TaskKey.registerUser] = nil }
      
      do {
        try Task.checkCancellation()
        let response = try await self.signUpWorker.registerUser(request: request)
        try Task.checkCancellation()
        self.presenter?.presentUserRegistrationSuccess(response: response)
      } catch let error {
        self.handleError(error: error)
      }
    }
  }
}

extension SignUpInteractor {
  enum TaskKey {
    case registerUser
    case isExistingCustomId
  }
  
  @MainActor
  private func handleError(error: Error) {
    debugPrint("\(error) on SignUpInteractor")
    self.presenter?.presentError(error: error)
  }
}
