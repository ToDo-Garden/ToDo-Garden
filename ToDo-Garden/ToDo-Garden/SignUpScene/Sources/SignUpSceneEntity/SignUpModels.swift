//
//  SignUpModels.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum SignUp {
  
  // MARK: Use cases
  
  public enum CheckStringValidation {
    public struct Request {
      public let text: String?
      public let currentPageIndex: Int
      
      public init(text: String?, currentPageIndex: Int) {
        self.text = text
        self.currentPageIndex = currentPageIndex
      }
    }
    public struct Response {
      public let validationState: ValidationState
      public let currentPageIndex: Int
      
      public init(validationState: ValidationState, currentPageIndex: Int) {
        self.validationState = validationState
        self.currentPageIndex = currentPageIndex
      }
    }
    public struct ViewModel {
      public let warningText: String
      public let currentPageIndex: Int
      
      public init(
        warningText: String,
        currentPageIndex: Int
      ) {
        self.warningText = warningText
        self.currentPageIndex = currentPageIndex
      }
    }
  }
}

extension SignUp {
  public enum ValidationState {
    case valid
    case invalid
    case empty
  }
}
