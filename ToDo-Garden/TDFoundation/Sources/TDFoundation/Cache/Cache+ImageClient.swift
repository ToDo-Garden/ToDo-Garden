import Foundation
import UIKit

import HTTPClient
import HTTPClientAPI

extension Cache where Request == ImageClient {
  public static let shared = Cache(request: ImageClient.live)
}

public struct ImageClient: Requestable {
  var request: @Sendable (URL) async throws -> Data
  
  public func execute(id: URL, isDownsample: Bool = false) async throws -> UIImage {
    let data = try await request(id)
    
    return isDownsample
    ? downsample(imageData: data, for: CGSize(width: 90, height: 90), scale: 1.0)
    : try UIImage(data: data) ?? { throw CocoaError(.coderInvalidValue) }()
  }
  
  private func downsample(imageData: Data, for size: CGSize, scale: CGFloat) -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)
      else { return UIImage() }
    
    let maxDimensionInPixels = max(size.width, size.height) * scale
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)
      else { return UIImage() }
    
    return UIImage(cgImage: downsampledImage)
  }
}

extension ImageClient {
  public static let live = ImageClient { url in
    try await HTTPClient.live.send(
      input: url,
      serializer: { HTTPRequest(method: HTTPMethod.get, endPoint: $0) },
      deserializer: { response in
        guard let data = response.body else {
          throw HTTPClientError.deserializationError
        }
        return data
      }
    )
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
