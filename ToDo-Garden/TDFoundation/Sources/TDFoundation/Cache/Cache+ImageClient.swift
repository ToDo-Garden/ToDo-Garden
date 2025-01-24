import Foundation
import UIKit

extension Cache where Request == ImageClient {
  public static let shared = Cache(request: ImageClient.live)
}

public struct ImageClient: Requestable {
  var request: @Sendable (URL) async throws -> Data
  
  public func execute(id: URL) async throws -> UIImage {
    let data = try await self.request(id)
    guard let image = UIImage(data: data) else {
      throw CocoaError(.coderInvalidValue)
    }
    return image
  }
}

extension ImageClient {
  public static let live = ImageClient { url in
    try await URLSession.shared.data(from: url).0
  }
}

extension UIImage: MemorySizeProvider {
  private var _renderedCGImage: CGImage? {
    let renderer = UIGraphicsImageRenderer(size: size)
    let renderedImage = renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
    return renderedImage.cgImage
  }
  
  public var estimatedMemory: Measurement<UnitInformationStorage> {
    get throws {
      guard let cgImage = self.cgImage ?? self._renderedCGImage else {
        throw Internals.canNotEstimate
      }
      let channels = cgImage.bitsPerPixel / cgImage.bitsPerComponent
      let bytesPerPixel = channels * (cgImage.bitsPerComponent / 8)
      
      return Measurement(
        value: Double(cgImage.width * cgImage.height * bytesPerPixel),
        unit: UnitInformationStorage.bytes
      )
    }
  }
  
  enum Internals: Error {
    case canNotEstimate
  }
}
