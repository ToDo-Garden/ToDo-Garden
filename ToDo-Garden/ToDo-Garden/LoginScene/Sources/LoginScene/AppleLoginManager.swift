//
//  AppleLoginManager.swift
//
//
//  Created by SONG on 10/4/24.
//

import AuthenticationServices
import Foundation

protocol AppleLoginManagerDelegate: AnyObject {
  func appleLoginDidComplete(with result: Result<ASAuthorizationAppleIDCredential, Error>)
}

final class AppleLoginManager: NSObject {
  private var authController: ASAuthorizationController?
  private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
  weak var delegate: AppleLoginManagerDelegate?
  
  init(presentationContextProvider: ASAuthorizationControllerPresentationContextProviding) {
    super.init()
    self.presentationContextProvider = presentationContextProvider
    self.setupAuthController()
  }
  
  private func setupAuthController() {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    
    request.requestedScopes = [ASAuthorization.Scope.email]
    
    self.authController = ASAuthorizationController(authorizationRequests: [request])
    self.authController?.delegate = self
    self.authController?.presentationContextProvider = self.presentationContextProvider
  }
  
  func performAppleLogin() {
    self.authController?.performRequests()
  }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      self.delegate?.appleLoginDidComplete(with: .success(appleIDCredential))
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.delegate?.appleLoginDidComplete(with: .failure(error))
  }
}
