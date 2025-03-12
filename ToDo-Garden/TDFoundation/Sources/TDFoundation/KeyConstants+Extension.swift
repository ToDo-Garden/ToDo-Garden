extension KeyConstants {
  public static var facebookAPIKey: String {
    get throws {
      try generate("FACEBOOK_API_KEY")
    }
  }
  
  public static var supabaseAPIKey: String {
    get throws {
      try generate("SUPABASE_API_KEY")
    }
  }
  
  public static var appBundleID: String {
    get throws {
      try generate("APP_BUNDLE_ID")
    }
  }
}

private func generate(_ key: String) throws -> String {
  guard let result = KeyConstants.storage[key] else {
    printWarning(key)
    throw InternalError.keyNotFound(key)
  }
  return result
}

private enum InternalError: Error {
  case keyNotFound(String)
}

private func printWarning(_ key: String) {
  debugPrint("⚠️ Warning: API Key for '\(key)' not found.")
}
