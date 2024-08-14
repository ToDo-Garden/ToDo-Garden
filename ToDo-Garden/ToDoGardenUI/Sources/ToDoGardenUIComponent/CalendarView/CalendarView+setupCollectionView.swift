//
//  CalendarView+setupCollectionView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

extension CalendarView {
  func configureCollectionView(_ collectionView: UICollectionView) {
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

  func makeCollectionViewLayout(with collectionViewModel: CalendarView.Model.CollectionViewLayout)
  -> UICollectionViewCompositionalLayout {
    let item = self.makeItem(with: collectionViewModel.itemSize)
    let group = self.makeGroup(by: item, with: collectionViewModel.itemSpacing)
    let section = self.makeSection(by: group, with: collectionViewModel.lineSpacing)
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = UICollectionView.ScrollDirection.horizontal
    
    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }
}

extension CalendarView {
  private func makeItem(with size: CGSize) -> NSCollectionLayoutItem {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.estimated(size.width),
      heightDimension: NSCollectionLayoutDimension.estimated(size.height)
    )
    return NSCollectionLayoutItem(layoutSize: itemSize)
  }

  private func makeGroup(
    by item: NSCollectionLayoutItem,
    with itemSpacing: CGFloat
  ) -> NSCollectionLayoutGroup {
    let groupSize = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
      heightDimension: item.layoutSize.heightDimension
    )
    
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = NSCollectionLayoutSpacing.flexible(itemSpacing)
    
    return group
  }

  private func makeSection(
    by group: NSCollectionLayoutGroup,
    with lineSpacing: CGFloat
  ) -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = lineSpacing
    section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
    section.visibleItemsInvalidationHandler = { _, _, _ in
      return
    }
    return section
  }
}
