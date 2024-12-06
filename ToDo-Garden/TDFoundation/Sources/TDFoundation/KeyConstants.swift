import Foundation

@MainActor
public enum KeyConstants {
  static fileprivate(set) var storage: [String: String] = {
    guard
      let url = Bundle.main.url(forResource: ".env", withExtension: nil)
    else {
      debugPrint("❌ Error: Could not locate .env in the app bundle.")
      return [:]
    }
    
    var dict: [String: String] = [:]
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
          dict[key] = value
        }
      }
      debugPrint("✅ Success: .env loaded and decoded successfully.")
    } catch {
      debugPrint("❌ Error: Failed to load .env - \(error.localizedDescription)")
    }
    
    return dict
  }()
}
