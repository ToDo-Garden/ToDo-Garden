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
  struct UserInfoSection: Hashable {
    let title: String
    let items: [UserInfoItem]
  }

  struct UserInfoItem: Hashable {
    let title: String
    let isRightImageExisted: Bool
    let position: SettingCollectionViewCell.Position
  }
}

extension UserInfoSceneViewController {
  typealias DiffableDataSource = UICollectionViewDiffableDataSource<UserInfoSection, UserInfoItem>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>

  func makeDiffableDataSource(with collectionView: UICollectionView) -> DiffableDataSource {
    let dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SettingCollectionViewCell.identifier,
        for: indexPath
      ) as? SettingCollectionViewCell else { return UICollectionViewCell() }

      cell.setupUI(
        title: itemIdentifier.title,
        titleFont: UIFont.pretendardBodyMedium,
        isShowingModal: itemIdentifier.isRightImageExisted,
        position: itemIdentifier.position
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
      supplementaryView.updateUI(title: section.title)
    }
  }
}
