//
//  ScrollView+Extension.swift
//  TDFoundation
//
//  Created by SONG on 1/20/25.
//

import UIKit

import TDUtility

extension UIScrollView {
  private var onEndReachedKey: String {
    return "onEndReachedKey"
  }
  
  public var onEndReached: (() -> Void)? {
    get {
      self.ao_get(key: self.onEndReachedKey) as? (() -> Void)
    }
    set {
      self.ao_setOptional(newValue, key: self.onEndReachedKey, policy: AssociationPolicy.copyNonatomic)
      self.setEndReachedDelegate()
    }
  }
  
  private func setEndReachedDelegate() {
    InfiniteScrollHandler.shared.originalDelegates[self] = self.delegate
    self.delegate = InfiniteScrollHandler.shared
  }
}

final class InfiniteScrollHandler: NSObject, UIScrollViewDelegate {
  static let shared = InfiniteScrollHandler()
  var originalDelegates: [UIScrollView: UIScrollViewDelegate?] = [:]
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard self.originalDelegates.keys.contains(scrollView) else { return }
    
    let height = scrollView.frame.size.height
    let contentYOffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYOffset
    let threshold: CGFloat = 200.0
    
    if distanceFromBottom < height + threshold {
      scrollView.onEndReached?()
    }
    
    self.originalDelegates[scrollView]??.scrollViewDidScroll?(scrollView)
  }
  
  @preconcurrency
  override func responds(to aSelector: Selector!) -> Bool {
    MainActor.assumeIsolated {
      if let scrollView = self.originalDelegates.keys.first(where: { $0.delegate === self }),
        let originalDelegate = self.originalDelegates[scrollView] {
        return super.responds(to: aSelector) || originalDelegate?.responds(to: aSelector) == true
      }
      return super.responds(to: aSelector)
    }
  }
  
  @preconcurrency
  override func forwardingTarget(for aSelector: Selector!) -> Any? {
    let target: UIScrollViewDelegate? = MainActor.assumeIsolated {
      if let scrollView = self.originalDelegates.keys.first(where: { $0.delegate === self }) {
        return self.originalDelegates[scrollView] ?? nil
      }
      return nil
    }
    return target
  }
}
// TODO: ⬇️ 이미지캐시 객체 교체 예정
// swiftlint: disable all
public final class ImageCache {
  public static let shared = ImageCache()
  
  private let cache = NSCache<NSURL, UIImage>()
  
  private init() {
    self.cache.totalCostLimit = 50 * 1024 * 1024
  }
  
  public func setObject(_ image: UIImage, forKey key: NSURL) {
    self.cache.setObject(image, forKey: key)
  }
  
  public func object(forKey key: NSURL) -> UIImage? {
    return self.cache.object(forKey: key)
  }
  
  public func removeObject(forKey key: NSURL) {
    self.cache.removeObject(forKey: key)
  }
  
  public func removeAllObjects() {
    self.cache.removeAllObjects()
  }
  
  public func loadImage(url: URL) async throws -> UIImage {
    let cacheKey = url as NSURL
    
    if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
      return cachedImage
    }
    
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
          let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    let apiKey = try KeyConstants.supabaseAPIKey
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("\(apiKey)", forHTTPHeaderField: "apiKey")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("todogarden", forHTTPHeaderField: "Accept-Profile")
    request.setValue("Bearer \(accessTokenString)", forHTTPHeaderField: "Authorization")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      
      if let downloadedImage = UIImage(data: data) {
        ImageCache.shared.setObject(downloadedImage, forKey: cacheKey)
        return downloadedImage
      } else {
        return UIImage(systemName: "xmark.circle") ?? UIImage()
      }
    } catch {
      return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
  }
}
// swiftlint: enable all
