//
//  AppleLoginManager.swift
//
//
//  Created by SONG on 10/4/24.
//

import AuthenticationServices

public protocol AppleLoginManagerDelegate: AnyObject {
  func appleLoginDidComplete(with result: Result<ASAuthorizationAppleIDCredential, Error>)
}

public final class AppleLoginManager: NSObject {
  private var authController: ASAuthorizationController?
  private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
  public weak var delegate: AppleLoginManagerDelegate?
  
  public init(presentationContextProvider: ASAuthorizationControllerPresentationContextProviding) {
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
  
  public func performAppleLogin() {
    self.authController?.performRequests()
  }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      self.delegate?.appleLoginDidComplete(with: .success(appleIDCredential))
    }
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.delegate?.appleLoginDidComplete(with: .failure(error))
  }
}
