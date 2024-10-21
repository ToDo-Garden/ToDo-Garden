//
//  UserInfoSceneViewController+makeDiffableDataSource.swift
//
//
//  Created by Wood on 9/2/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource
import UserInfoSceneEntity

extension UserInfoSceneViewController {
  typealias DiffableDataSource = UICollectionViewDiffableDataSource<UserInfoSection, UserInfoItem>
  typealias CellRegistration = UICollectionView.CellRegistration<UserInfoCollectionViewCell, UserInfoItem>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>

  func makeDiffableDataSource(with collectionView: UICollectionView) -> DiffableDataSource {
    let cellRegistration = self.makeCellRegistration(with: collectionView)
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

  private func makeCellRegistration(with collectionView: UICollectionView) -> CellRegistration {
    return CellRegistration { cell, indexPath, item in
      let cellPosition = self.getCellPosition(of: indexPath, collectionView: collectionView)
      cell.setupUI(
        title: item.title,
        titleFont: UIFont.pretendardBodyMedium,
        isShowingModal: item.isRightImageExisted,
        position: cellPosition
      )
      self.setupButtonAction(to: cell, with: item)
      cell.updateUserInfo(item.userInfo, with: self.interactor)
    }
  }

  private func getCellPosition(
    of indexPath: IndexPath,
    collectionView: UICollectionView
  ) -> SettingCollectionViewCell.Position {
    let rowCount = collectionView.numberOfItems(inSection: indexPath.section)
    if indexPath.item == 0 {
      return SettingCollectionViewCell.Position.top
    } else if indexPath.item == rowCount - 1 {
      return SettingCollectionViewCell.Position.bottom
    } else {
      return SettingCollectionViewCell.Position.middle
    }
  }

  private func setupButtonAction(to cell: UserInfoCollectionViewCell, with item: UserInfoItem) {
    let action = UIAction { [weak self] _ in
      self?.handleRoute(for: item)
    }
    cell.setupRightButtonAction(action)
  }

  private func handleRoute(for item: UserInfoItem) {
    switch item.userInfo {
    case UserInfoScene.UserInfo.introduction:
      self.router?.routeToEditUserIntroductionScene()
    case UserInfoScene.UserInfo.nickName:
      self.router?.routeToEditUserNameScene()
    default:
      break
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
      supplementaryView.updateUI(title: section.title)
    }
  }
}
