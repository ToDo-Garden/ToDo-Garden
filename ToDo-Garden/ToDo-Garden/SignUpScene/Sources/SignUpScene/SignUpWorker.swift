//
//  SignUpWorker.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import HTTPClientAPI
import SignUpSceneAPI
import SignUpSceneEntity
import TDFoundation
import TDUtility

public struct SignUpWorker: SignUpWorkable {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func checkStringValidation(text: String?, currentPageIndex: Int) -> SignUp.ValidationState {
    guard let text else {
      return SignUp.ValidationState.empty
    }
    switch currentPageIndex {
    case 0:
      if StringValidationChecker.isValidID(text) {
        return SignUp.ValidationState.valid
      } else {
        return SignUp.ValidationState.invalid
      }
    case 1:
      if StringValidationChecker.isValidIntroduction(text) {
        return SignUp.ValidationState.valid
      } else {
        return SignUp.ValidationState.invalid
      }
    case 2:
      if StringValidationChecker.isValidNickName(text) {
        return SignUp.ValidationState.valid
      } else {
        return SignUp.ValidationState.invalid
      }
    default:
      return SignUp.ValidationState.empty
    }
  }
  
  public func registerUser(request: SignUp.RegisterUser.Request) async throws -> SignUp.RegisterUser.Response {

    let requestDTO = SignUp.RegisterUser.RequestDTO(
      customId: request.customId,
      nickname: request.nickname,
      introduction: request.introduction ?? ""
    )
    let result = try await self.requestForRegistering(with: requestDTO)
    
    return SignUp.RegisterUser.Response(isSuccess: result)
  }
}

extension SignUpWorker {
  private func requestForRegistering(with dto: SignUp.RegisterUser.RequestDTO) async throws -> Bool {
    let result = try await self.httpClient.send(
      input: dto,
      serializer: { data in
        let jsonData = try JSONEncoder().encode(data)
        
        return HTTPRequest(
          method: HTTPMethod.post,
          endPoint: URLConstants.Auth.signUpURL,
          body: jsonData
        )
      },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          if let data = response.body,
          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let errorMessage = json["message"] as? String {
            if errorMessage.contains("User already exists") {
              throw SignUp.SignUpError.userIDAlreadyExisted
            }
          }
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        return true
      }
    )
    // TODO: Response로 뭐가 오는지 확인 후 변경 가능성 있음
    // throw 되지 않고 여기까지 도달하면 성공한거임.
    return result
  }
}
