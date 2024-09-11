//
//  UserInfoSceneViewController+makeDiffableDataSource.swift
//
//
//  Created by Wood on 9/2/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

extension UserInfoSceneViewController {
  typealias DiffableDataSource = UICollectionViewDiffableDataSource<UserInfoSection, UserInfoItem>
  typealias CellRegistration = UICollectionView.CellRegistration<SettingCollectionViewCell, UserInfoItem>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>

  func makeDiffableDataSource(with collectionView: UICollectionView) -> DiffableDataSource {
    let cellRegistration = self.makeCellRegistration()
    let dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: itemIdentifier
      )
    }

    dataSource.supplementaryViewProvider = self.makeSupplementaryViewProvider(with: dataSource)
    return dataSource
  }

  private func makeCellRegistration() -> CellRegistration {
    return CellRegistration { cell, _, item in
      let cellPosition = self.getCellPosition(of: item.position)
      cell.setupUI(
        title: item.title.rawValue,
        titleFont: UIFont.pretendardBodyMedium,
        isShowingModal: item.isRightImageExisted,
        position: cellPosition
      )
    }
  }

  private func getCellPosition(of position: UserInfoItem.Position) -> SettingCollectionViewCell.Position {
    switch position {
    case UserInfoItem.Position.top:
      return SettingCollectionViewCell.Position.top
    case UserInfoItem.Position.middle:
      return SettingCollectionViewCell.Position.middle
    case UserInfoItem.Position.bottom:
      return SettingCollectionViewCell.Position.bottom
    }
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
      supplementaryView.updateUI(title: section.title.rawValue)
    }
  }
}
