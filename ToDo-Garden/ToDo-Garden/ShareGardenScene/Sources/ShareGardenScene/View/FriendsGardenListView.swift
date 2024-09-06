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
  final class FriendsGardenListView: UIView {
    private lazy var friendsGardenListDataSource: DataSource = self.setupDataSource()
    private lazy var friendListView: UICollectionView = {
      let friendListView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: Self.makeFreindsGardenListViewLayout()
      )
      friendListView.delegate = self
      friendListView.backgroundColor = UIColor.white
      
      return friendListView
    }()
    
    private let gradientLayer: CAGradientLayer = {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [
        UIColor.white.withAlphaComponent(1.0).cgColor,
        UIColor.white.withAlphaComponent(0.8).cgColor,
        UIColor.white.withAlphaComponent(0.3).cgColor,
        UIColor.white.withAlphaComponent(0.0).cgColor
      ]
      gradientLayer.locations = [0.0, 0.4, 0.8, 1.0]
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
      gradientLayer.isHidden = true
      
      return gradientLayer
    }()
    
    override var bounds: CGRect {
      didSet {
        if self.bounds.width != CGFloat.zero && self.isGradientLayerAdded == false {
          self.addGradientLayer()
        }
      }
    }
    
    private static let layoutConstant = ShareGardenSceneViewController.Constant.Layout.FriendsGardenListView.self
    
    private var isGradientLayerAdded: Bool = false
    private let friendsGardenStore: FriendsGardenStore
    
    init(friendsGardenStore: FriendsGardenStore) {
      self.friendsGardenStore = friendsGardenStore
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    
    /// FriendsGardenListView에 로딩 상태를 설정합니다.
    /// - Parameter numberOfCells: 표시될 placeholder cell의 숫자입니다.
    func setLoadingState(numberOfCells: Int) {
      self.isUserInteractionEnabled = false
      var snapshot = self.friendsGardenListDataSource.snapshot()
      
      if snapshot.sectionIdentifiers.contains(Section.main) == false {
        snapshot.appendSections([Section.main])
      }
      
      var items = [Item]()
      
      for _ in 0 ..< numberOfCells {
        let uuid = UUID()
        items.append(Item.loading(uuid))
      }
      
      snapshot.appendItems(items)
      self.friendsGardenListDataSource.apply(snapshot)
    }
    
    func endLoading() {
      self.isUserInteractionEnabled = true
      self.friendsGardenListDataSource.apply(Snapshot())
    }
    
    func append(_ identifiers: [ShareGardenScene.FriendsGarden.ID]) {
      var snapshot = self.friendsGardenListDataSource.snapshot()
      if snapshot.sectionIdentifiers.contains(Section.main) == false {
        snapshot.appendSections([Section.main])
      }
      let items = identifiers.map { Item.friendsGarden($0) }
      snapshot.appendItems(items, toSection: Section.main)
      self.friendsGardenListDataSource.apply(snapshot)
    }
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func setup() {
    self.addSubviews()
    self.setupLayoutCosntraints()
  }
  
  private func addSubviews() {
    self.addSubview(self.friendListView)
  }
}

// MARK: - Type info

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private enum Section {
    case main
  }
  
  private enum Item: Hashable {
    case friendsGarden(ShareGardenScene.FriendsGarden.ID)
    case loading(UUID)
  }
  
  private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
  private typealias FriendsGardenListViewCell =
  ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewCell
  private typealias FriendsGardenListViewLoadingCell =
  ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewLoadingCell
  private typealias Snapshot =
  NSDiffableDataSourceSnapshot<
    ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView.Section,
    Item
  >
  private typealias FriendsGardenListViewCellRegistration = UICollectionView.CellRegistration<
    FriendsGardenListViewCell,
    Item
  >
  
  private typealias LoadingCellRegistration = UICollectionView.CellRegistration<
    FriendsGardenListViewLoadingCell,
    Item
  >
}

// MARK: - layout

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private static func makeFreindsGardenListViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(
        Self.layoutConstant.fullWidthRatio
      ),
      heightDimension: NSCollectionLayoutDimension.estimated(
        Self.layoutConstant.estimatedItemHeight
      )
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: itemSize,
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func setupLayoutCosntraints() {
    self.setupFriendListViewLayoutConstraints()
  }
  
  private func setupFriendListViewLayoutConstraints() {
    self.friendListView.equalToParent()
  }
}

// MARK: - Data Source

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func setupDataSource() -> DataSource {
    let friendsGardenListViewCellRegistration = FriendsGardenListViewCellRegistration { [weak self] cell, _, item in
      guard case let Item.friendsGarden(identifier) = item,
        let friendsGarden = self?.friendsGardenStore.fetchBy(identifier)
      else { return }
      
      cell.configure(with: friendsGarden)
    }
    
    let loadingCellRegistration = LoadingCellRegistration { cell, _, _ in
      cell.configure()
    }
    
    return DataSource(collectionView: self.friendListView) { collectionView, indexPath, item in
      switch item {
      case Item.loading:
        return collectionView.dequeueConfiguredReusableCell(
          using: loadingCellRegistration,
          for: indexPath,
          item: item
        )
      case Item.friendsGarden(_):
        return collectionView.dequeueConfiguredReusableCell(
          using: friendsGardenListViewCellRegistration,
          for: indexPath,
          item: item
        )
      }
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
      collectionView.deselectItem(at: indexPath, animated: true)
    } else {
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    return false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let isStartPointReached = scrollView.contentOffset.y <= CGFloat.zero
    self.gradientLayer.isHidden = isStartPointReached
  }
}

// MARK: - Gradient layer

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func addGradientLayer() {
    self.gradientLayer.frame = CGRect(
      x: CGFloat.zero,
      y: CGFloat.zero,
      width: self.bounds.width,
      height: Self.layoutConstant.gradientLayerHeight
    )
    self.layer.addSublayer(self.gradientLayer)
    self.isGradientLayerAdded = true
  }
}
