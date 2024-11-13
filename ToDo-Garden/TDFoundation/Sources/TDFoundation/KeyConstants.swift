import Foundation

// swiftlint:disable function_body_length
@MainActor
public enum KeyConstants {
  static fileprivate(set) var storage = [String: String]()
  
  public static func load() async throws {
    guard
      let url = Bundle.main.url(forResource: ".env", withExtension: nil)
    else {
      debugPrint("❌ Error: Could not locate .env in the app bundle.")
      return
    }
    
    do {
      let data = try String(contentsOf: url, encoding: .utf8)
      let lines = data.split(separator: "\n")
      
      for line in lines {
        let parts = line
          .split(separator: "=", maxSplits: 1)
          .map(String.init)
        if parts.count == 2 {
          let key = parts[0]
            .trimmingCharacters(in: .whitespaces)
          let value = parts[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
          Self.storage[key] = value
        }
      }
      debugPrint("✅ Success: .env loaded and decoded successfully.")
    } catch {
      debugPrint("❌ Error: Failed to load .env - \(error.localizedDescription)")
      throw error
    }
  }
}

extension KeyConstants {
  public static var facebookAPIKey: String {
    let key = "FACEBOOK_API_KEY"
    guard
      !Self.storage.isEmpty,
      let result = Self.storage[key]
    else {
      printWarning(key)
      return ""
    }
    
    return result
  }
}

private func printWarning(_ key: String) {
  debugPrint("⚠️ Warning: API Key for '\(key)' not found. Ensure you call KeyConstants.load() before accessing keys.")
}
// swiftlint:enable function_body_length
