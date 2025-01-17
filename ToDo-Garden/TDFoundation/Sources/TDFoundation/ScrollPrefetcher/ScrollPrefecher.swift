//
//  ScrollPrefecher.swift
//  SearchGardenScene
//
//  Created by SONG on 1/12/25.
//

import UIKit

@objc public protocol PrefetcherDelegate: AnyObject, UITableViewDelegate, UICollectionViewDelegate {
  func scrollDidReachBottom(_ prefetcher: ScrollPrefecher)
  func prefetcher(_ prefetcher: ScrollPrefecher, didRequestPrefetchFor indexPaths: [IndexPath])
  @objc optional func prefetcher(_ prefetcher: ScrollPrefecher, didCancelPrefetchFor indexPaths: [IndexPath])
}

@MainActor
public final class ScrollPrefecher:
  NSObject,
  UITableViewDataSourcePrefetching,
  UITableViewDelegate,
  UICollectionViewDelegate,
  UICollectionViewDataSourcePrefetching {
  public static let shared = ScrollPrefecher()
  
  public weak var prefetchDelegate: PrefetcherDelegate?
  public weak var tableViewDelegate: UITableViewDelegate? {
    willSet {
      if self.collectionViewDelegate != nil {
        self.collectionViewDelegate = nil
      }
    }
  }
  public weak var collectionViewDelegate: UICollectionViewDelegate? {
    willSet {
      if self.tableViewDelegate != nil {
        self.tableViewDelegate = nil
      }
    }
  }
  
  private override init() {
    super.init()
  }
  
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    self.prefetchDelegate?.prefetcher(self, didRequestPrefetchFor: indexPaths)
  }
  
  public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    self.prefetchDelegate?.prefetcher?(self, didCancelPrefetchFor: indexPaths)
  }
  
  public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    self.prefetchDelegate?.prefetcher(self, didRequestPrefetchFor: indexPaths)
  }
  
  public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    self.prefetchDelegate?.prefetcher?(self, didCancelPrefetchFor: indexPaths)
  }
  
  // MARK: - Scroll Handling
  // swiftlint: disable function_body_length
  public func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let contentHeight = scrollView.contentSize.height
    let scrollViewHeight = scrollView.bounds.height
    let targetOffsetY = targetContentOffset.pointee.y
    
    if velocity.y > 2.0 {
      let nearBottom = targetOffsetY + scrollViewHeight >= contentHeight - 300
      if nearBottom {
        self.prefetchDelegate?.scrollDidReachBottom(self)
      }
    } else {
      let nearBottom = targetOffsetY + scrollViewHeight >= contentHeight - 100
      if nearBottom {
        self.prefetchDelegate?.scrollDidReachBottom(self)
      }
      
      if let tableView = scrollView as? UITableView {
        tableViewDelegate?.scrollViewWillEndDragging?(
          tableView,
          withVelocity: velocity,
          targetContentOffset: targetContentOffset
        )
      } else if let collectionView = scrollView as? UICollectionView {
        collectionViewDelegate?.scrollViewWillEndDragging?(
          collectionView,
          withVelocity: velocity,
          targetContentOffset: targetContentOffset
        )
      }
    }
  }
  // swiftlint: enable function_body_length

  public override func responds(to aSelector: Selector!) -> Bool {
    if let tableViewDelegate = self.tableViewDelegate, tableViewDelegate.responds(to: aSelector) {
      return true
    } else if let collectionViewDelegate = self.collectionViewDelegate, collectionViewDelegate.responds(to: aSelector) {
      return true
    }
    return super.responds(to: aSelector)
  }

  public override func forwardingTarget(for aSelector: Selector!) -> Any? {
    if self.tableViewDelegate?.responds(to: aSelector) == true {
      return self.tableViewDelegate
    } else if self.collectionViewDelegate?.responds(to: aSelector) == true {
      return self.collectionViewDelegate
    }
    return nil
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
