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
    public struct Request: Sendable {
      public let text: String?
      public let currentPageIndex: Int
      
      public init(text: String?, currentPageIndex: Int) {
        self.text = text
        self.currentPageIndex = currentPageIndex
      }
    }
    public struct Response: Sendable {
      public let validationState: ValidationState
      public let currentPageIndex: Int
      
      public init(validationState: ValidationState, currentPageIndex: Int) {
        self.validationState = validationState
        self.currentPageIndex = currentPageIndex
      }
    }
    public struct ViewModel: Sendable {
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
  
  public enum RegisterUser {
    public struct Request: Sendable {
      public let customId: String
      public let nickname: String
      public let introduction: String?
      
      public init(customId: String, nickname: String, introduction: String?) {
        self.customId = customId
        self.nickname = nickname
        self.introduction = introduction
      }
    }
    
    public struct Response: Sendable {
      public let isSuccess: Bool
      
      public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
      }
    }
    public struct ViewModel: Sendable {
      public let isSuccess: Bool
      
      public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
      }
    }
    
    public struct RequestDTO: Codable, Sendable {
      public let customid: String
      public let nickname: String
      public let introduction: String
      // TODO: 광고성 이벤트 동의여부 추가
      public init(
        customId: String,
        nickname: String,
        introduction: String
      ) {
        self.customid = customId
        self.nickname = nickname
        self.introduction = introduction
      }
    }
    
    public struct ResponseDTO: Codable, Sendable {
      public init() { }
    }
  }
}

extension SignUp {
  public enum ValidationState: Sendable {
    case valid
    case invalid
    case empty
  }
  
  public enum SignUpError: Sendable, Error {
    case userIDAlreadyExisted
    case unknownError
  }
}
