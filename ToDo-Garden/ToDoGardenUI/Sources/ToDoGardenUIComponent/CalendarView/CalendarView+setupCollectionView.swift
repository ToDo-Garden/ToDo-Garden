//
//  CalendarView+setupCollectionView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

extension CalendarView {
  func setupCollectionView(_ collectionView: UICollectionView) {
    self.configure(collectionView)
  }

  private func configure(_ collectionView: UICollectionView) {
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.alwaysBounceHorizontal = true
    collectionView.isPagingEnabled = true
    collectionView.isScrollEnabled = true
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    collectionView.register(
      CalendarCollectionViewCell.self,
      forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier
    )
  }
}
