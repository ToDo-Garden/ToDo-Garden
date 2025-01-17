//
//  Prefetcher+UI+Extension.swift
//  TDFoundation
//
//  Created by SONG on 1/16/25.
//

import UIKit

extension UITableView {
  public func setPrefetcher(_ prefetcher: ScrollPrefecher) {
    self.prefetchDataSource = prefetcher
    self.delegate = prefetcher
  }
}

extension UICollectionView {
  public func setPrefetcher(_ prefetcher: ScrollPrefecher) {
    self.prefetchDataSource = prefetcher
    self.delegate = prefetcher
  }
}
