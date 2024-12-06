extension KeyConstants {
  public static var facebookAPIKey: String {
    get throws {
      try generate("FACEBOOK_API_KEY")
    }
  }
}
extension KeyConstants {
  enum InternalError: Error {
    case keyNotFound(String)
  }
  
  static func generate(_ key: String) throws -> String {
    guard let result = KeyConstants.storage[key] else {
      printWarning(key)
      throw KeyConstants.InternalError.keyNotFound(key)
    }
    return result
  }
}

private func printWarning(_ key: String) {
  debugPrint("⚠️ Warning: API Key for '\(key)' not found. Ensure you call KeyConstants.load() before accessing keys.")
}
