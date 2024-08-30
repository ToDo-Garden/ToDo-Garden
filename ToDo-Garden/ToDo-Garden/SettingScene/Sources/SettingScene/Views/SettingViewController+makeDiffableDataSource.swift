//
//  SettingViewController+makeDiffableDataSource.swift
//
//
//  Created by Wood on 8/22/24.
//

import UIKit

import ToDoGardenUIComponent

extension SettingViewController {
  typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>

  func makeDiffableDataSource(with collectionView: UICollectionView) -> DiffableDataSource {
    let dataSource = DiffableDataSource(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SettingCollectionViewCell.identifier,
        for: indexPath
      ) as? SettingCollectionViewCell else { return UICollectionViewCell() }

      cell.setupUI(
        title: item.title,
        titleFont: UIFont.pretendardBodyRegular,
        isShowingModal: item.isShowingModal,
        position: item.position
      )

      return cell
    }

    dataSource.supplementaryViewProvider = self.makeSupplementaryViewProvider(with: dataSource)
    return dataSource
  }

  private func makeSupplementaryViewProvider(
    with dataSource: DiffableDataSource
  ) -> DiffableDataSource.SupplementaryViewProvider {
    let headerRegistration = self.makeHeaderRegistration(with: dataSource)
    return { (collectionView, _, indexPath) in
      return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }
  }

  private func makeHeaderRegistration(with dataSource: DiffableDataSource) -> HeaderRegistration {
    return HeaderRegistration(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { supplementaryView, _, indexPath in
      let snapshot = dataSource.snapshot()
      let section = snapshot.sectionIdentifiers[indexPath.section]
      supplementaryView.updateUI(image: section.image, title: section.title)
    }
  }
}
