//
//  FriendsGardenListView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/23/24.
//

import UIKit

import ShareGardenSceneEntity

protocol FriendsGardenStore {
  func fetchBy(_ id: ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden?
}

extension ShareGardenSceneViewController.FriendsGardenView {
  final class FriendsGardenListView: UICollectionView {
    private let friendsGardenStore: FriendsGardenStore
    private lazy var friendsGardenListDataSource: DataSource = self.setupDataSource()
    
    init(friendsGardenStore: FriendsGardenStore) {
      self.friendsGardenStore = friendsGardenStore
      super.init(
        frame: CGRect.zero,
        collectionViewLayout: Self.makeFreindsGardenListViewLayout()
      )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func append(_ identifiers: [ShareGardenScene.FriendsGarden.ID]) {
      var snapshot = self.friendsGardenListDataSource.snapshot()
      self.appendMainSectionIfNeeded(&snapshot)
      snapshot.appendItems(identifiers, toSection: Section.main)
      self.friendsGardenListDataSource.apply(snapshot)
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func appendMainSectionIfNeeded(_ snapshot: inout Snapshot) {
    if snapshot.sectionIdentifiers.contains(Section.main) == false {
      snapshot.appendSections([Section.main])
    }
  }
}

// MARK: - Type info

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private enum Section {
    case main
  }
  
  private typealias DataSource = UICollectionViewDiffableDataSource<Section, ShareGardenScene.FriendsGarden.ID>
  private typealias FriendsGardenListViewCell =
  ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewCell
  private typealias Snapshot =
  NSDiffableDataSourceSnapshot<
    ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView.Section,
    ShareGardenScene.FriendsGarden.ID
  >
}

// MARK: - layout

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private static func makeFreindsGardenListViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
      heightDimension: NSCollectionLayoutDimension.estimated(48)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: itemSize,
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - Data Source

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func setupDataSource() -> DataSource {
    let cellRegistration = UICollectionView.CellRegistration<
      FriendsGardenListViewCell,
      ShareGardenScene.FriendsGarden.ID
    > { [weak self] cell, _, identifier in
      guard let friendsGarden = self?.friendsGardenStore.fetchBy(identifier)
      else { return }
      
      cell.configure(with: friendsGarden)
    }
    
    return DataSource(collectionView: self) { collectionView, indexPath, identifier in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
    }
  }
}

