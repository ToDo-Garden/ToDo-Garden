//
//  KeychainManager.swift
//
//
//  Created by SONG on 10/23/24.
//

import Foundation
import Security

public final class KeychainManager: Sendable {
  public static let shared = KeychainManager()
  
  private init() {}
  
  public enum KeychainKey {
    static let userIdentifier = "user_identifier"
    static let identifyToken = "identity_token"
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
    // MARK: - 필요한 키값을 직접 추가하세요
  }
  
  public func create(_ data: Data, forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: data,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    if status == errSecSuccess {
      return
    } else if status == errSecDuplicateItem {
      throw KeychainError.alreadyExistentKey
    } else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  public func update(_ data: Data, forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key
    ]
    
    let attributesToUpdate: [String: Any] = [
      kSecValueData as String: data
    ]
    
    let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  public func load(forKey key: String) throws -> Data? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: kCFBooleanTrue as Any, // 강제 언래핑 제거를 위한 "as Any"
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    switch status {
    case errSecSuccess:
      return result as? Data
    case errSecItemNotFound:
      throw KeychainError.nonExistentKey
    default:
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  public func delete(forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unhandledError(status: status)
    }
  }
}

// MARK: - Login / 인증 관련

extension KeychainManager {
  public func saveLoginData(identifier: String, identifyToken: Data) throws {
    try self.clearLoginData()
    
    try self.create(Data(identifier.utf8), forKey: KeychainKey.userIdentifier)
    try self.create(identifyToken, forKey: KeychainKey.identifyToken)
  }
  
  public func getLoginData() throws -> (identifier: String, identifyToken: String) {
    guard let identifierData = try self.load(forKey: KeychainKey.userIdentifier),
      let identifier = String(data: identifierData, encoding: String.Encoding.utf8),
      let tokenData = try self.load(forKey: KeychainKey.identifyToken),
      let identifyToken = String(data: tokenData, encoding: String.Encoding.utf8)
    else {
      throw KeychainError.unknownError
    }
    return (identifier, identifyToken)
  }
  
  public func clearLoginData() throws {
    try self.delete(forKey: KeychainKey.userIdentifier)
    try self.delete(forKey: KeychainKey.identifyToken)
  }
  
  public func saveAccessToken(accessToken: String, refreshToken: String) throws {
    try self.clearLoginData()
    
    try self.create(Data(accessToken.utf8), forKey: KeychainKey.userIdentifier)
    try self.create(Data(refreshToken.utf8), forKey: KeychainKey.identifyToken)
  }
  
  public func clearAccessToken() throws {
    try self.delete(forKey: KeychainKey.accessToken)
    try self.delete(forKey: KeychainKey.refreshToken)
  }
}

public enum KeychainError: Error {
  case nonExistentKey
  case alreadyExistentKey
  case unhandledError(status: OSStatus)
  case unknownError
}
