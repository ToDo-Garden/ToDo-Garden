//
//  AppleLoginManager.swift
//
//
//  Created by SONG on 10/4/24.
//

import AuthenticationServices
import HTTPClientAPI

public protocol AppleLoginManagerDelegate: AnyObject {
  func appleLoginDidComplete(with result: Result<Bool, Error>)
}

public final class AppleLoginManager: NSObject {
  private var authController: ASAuthorizationController?
  private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
  public weak var delegate: AppleLoginManagerDelegate?
  private let httpClient: HTTPClientAPI
  
  public init(
    presentationContextProvider: ASAuthorizationControllerPresentationContextProviding,
    httpClient: HTTPClientAPI
  ) {
    self.httpClient = httpClient
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
          identifyToken: appleIDCredential.identityToken ?? Data()
        )
        
        Task { [weak self] in
          let isMember = try await self?.requestVerificationToSupabase()
          self?.delegate?.appleLoginDidComplete(with: .success(isMember ?? false))
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

// swiftlint: disable function_body_length
extension AppleLoginManager {
  func requestVerificationToSupabase() async throws -> Bool {
    guard let token = try String(data: KeychainManager.shared.load(
      forKey: KeychainManager.KeychainKey.identifyToken) ?? Data(), encoding: .utf8
    ) else { throw KeychainError.nonExistentKey }
    
    let verificationResult = try await self.httpClient.send(
      input: LoginRequestDTO(
        id_token: token,
        provider: "apple"
      ),
      serializer: { data in
        let jsonData = try JSONEncoder().encode(data)
        
        return HTTPRequest(
          method: .post,
          endPoint: URLConstants.Auth.appleLoginURL,
          header: [
            "Content-Type": "application/json"
          ],
          body: jsonData
        )
      },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let data = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        let loginResponse = try JSONDecoder().decode(LoginResponseDTO.self, from: data)
        
        try KeychainManager.shared.saveAccessToken(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
          userIdentifier: loginResponse.user.id
        )
        
        let isSuccess = true
        return isSuccess
      }
    )
    
    let isExistingUser = try await requestIsExistingUser()
    // supaBase 인증 성공 && 기존유저 -> true
    // supaBase 인증 성공 && 신규유저 -> false
    // supaBase 인증 실패 -> throw Error
    return verificationResult && isExistingUser
  }
  
  func requestIsExistingUser() async throws -> Bool {
    guard let accessToken = try String(
      data: KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken) ?? Data(),
      encoding: .utf8
    ) else {
      throw KeychainError.nonExistentKey
    }

    let result = try await self.httpClient.send(
      input: IsExistingUserRequestDTO(),
      serializer: { _ in
        return HTTPRequest(
          method: .get,
          endPoint: URLConstants.Auth.validateUserURL,
          header: [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)",
            "Accept-Profile": "todogarden"
          ]
        )
      },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let boolString = String(data: response.body ?? Data(), encoding: .utf8),
          let bool = Bool(boolString) else {
          throw HTTPClientError.deserializationError
        }
        
        return bool
      }
    )
    return result
  }
}
// swiftlint: enable function_body_length

// swiftlint: disable identifier_name
struct LoginRequestDTO: Sendable, Codable {
  let id_token: String
  let provider: String
}

struct LoginResponseDTO: Sendable, Codable {
  let accessToken: String
  let refreshToken: String
  let user: UserDTO
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case user
  }
}

struct UserDTO: Sendable, Codable {
  let id: String
}

struct IsExistingUserRequestDTO: Sendable, Codable {

}
// swiftlint: enable identifier_name
