//
//  SettingViewController+makeCompositionalLayout.swift
//
//
//  Created by Wood on 8/22/24.
//

import UIKit

extension SettingViewController {
  func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let items = self.makeItem()
    let group = self.makeGroup(with: items)
    let section = self.makeSection(with: group)

    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.interSectionSpacing = 22

    return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
  }

  private func makeItem() -> NSCollectionLayoutItem {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
      heightDimension: NSCollectionLayoutDimension.estimated(40)
    )
    return NSCollectionLayoutItem(layoutSize: itemSize)
  }

  private func makeGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
    let groupSize = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
      heightDimension: NSCollectionLayoutDimension.estimated(1.0)
    )

    return NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
  }

  private func makeSection(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = self.makeSupplementaryItems()
    return section
  }

  private func makeSupplementaryItems() -> [NSCollectionLayoutBoundarySupplementaryItem] {
    return [
      NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
          heightDimension: NSCollectionLayoutDimension.estimated(22)
        ),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: NSRectAlignment.top
      )
    ]
  }
}
