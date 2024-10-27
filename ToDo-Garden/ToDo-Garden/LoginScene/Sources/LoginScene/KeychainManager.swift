//
//  KeychainManager.swift
//
//
//  Created by SONG on 10/23/24.
//

import Foundation
import Security

final class KeychainManager {
  static let shared = KeychainManager()
  
  private init() {}
  
  private enum KeychainKey {
    static let userIdentifier = "user_identifier"
    static let userEmail = "user_email"
    static let identifyToken = "identity_token"
    // MARK: - 필요한 키값을 직접 추가하세요
  }
  
  func create(_ data: Data, forKey key: String) throws {
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
  
  func update(_ data: Data, forKey key: String) throws {
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
  
  func load(forKey key: String) throws -> Data? {
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
  
  func delete(forKey key: String) throws {
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

// MARK: - Login 관련

extension KeychainManager {
  func saveLoginData(identifier: String, identifyToken: Data, email: String?) throws {
    try self.clearLoginData()
    
    try self.create(Data(identifier.utf8), forKey: KeychainKey.userIdentifier)
    try self.create(identifyToken, forKey: KeychainKey.identifyToken)
    
    if let email = email {
      try self.create(Data(email.utf8), forKey: KeychainKey.userEmail)
    } else {
      try self.create(Data(), forKey: KeychainKey.userEmail)
    }
  }
  
  // swiftlint:disable large_tuple
  func getLoginData() throws -> (identifier: String, identifyToken: String, email: String?)? {
    guard let identifierData = try self.load(forKey: KeychainKey.userIdentifier),
      let identifier = String(data: identifierData, encoding: String.Encoding.utf8),
      let tokenData = try self.load(forKey: KeychainKey.identifyToken),
      let identifyToken = String(data: tokenData, encoding: String.Encoding.utf8)
    else {
      return nil
    }
    
    let emailData = try self.load(forKey: KeychainKey.userEmail)
    let email = emailData.flatMap { String(data: $0, encoding: String.Encoding.utf8) }
    return (identifier, identifyToken, email)
  }
  // swiftlint:enable large_tuple
  
  func clearLoginData() throws {
    try self.delete(forKey: KeychainKey.userIdentifier)
    try self.delete(forKey: KeychainKey.userEmail)
    try self.delete(forKey: KeychainKey.identifyToken)
  }
}

enum KeychainError: Error {
  case nonExistentKey
  case alreadyExistentKey
  case unhandledError(status: OSStatus)
}
