//
//  AppleLoginManager.swift
//
//
//  Created by SONG on 10/4/24.
//

import AuthenticationServices

public protocol AppleLoginManagerDelegate: AnyObject {
  func appleLoginDidComplete(with result: Result<Bool, Error>)
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
      do {
        try KeychainManager.shared.saveLoginData(
          identifier: appleIDCredential.user,
          identifyToken: appleIDCredential.identityToken ?? Data(),
          email: appleIDCredential.email
        )
        
        Task {
          let isExistingUser = try await self.requestVerificationToSupabase()
          self.delegate?.appleLoginDidComplete(with: .success(isExistingUser))
        }
      } catch let error {
        self.delegate?.appleLoginDidComplete(with: .failure(error))
      }
    }
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.delegate?.appleLoginDidComplete(with: .failure(error))
  }
}

extension AppleLoginManager {
  func requestVerificationToSupabase() async throws -> Bool {
    if let token = try KeychainManager.shared.load(forKey: "identity_token") {
      // HTTP 로그인 요청
      // response에 기존 / 신규 유저 여부 포함
    }
    
    // supaBase 인증 성공 && 기존유저 -> true
    // supaBase 인증 성공 && 신규유저 -> false
    // supaBase 인증 실패 -> throw Error
    return true
  }
}
