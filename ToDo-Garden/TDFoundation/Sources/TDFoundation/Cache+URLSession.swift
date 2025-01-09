import Foundation
import class UIKit.UIImage

extension URLSession: Requestable {
  public func execute(id url: URL) async throws -> Data {
    try await self.data(from: url).0
  }
}

extension Cache where Request == URLSession {
  static let shared = Cache(request: URLSession.shared)
  
  func image(_ url: URL) async throws -> UIImage? {
    let data = try await self.execute(url)
    return UIImage(data: data)
  }
}
