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
        self.addGradientLayerIfNeeded()
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
    
    func append(_ identifiers: [ShareGardenScene.FriendsGarden.ID]) {
      var snapshot = self.friendsGardenListDataSource.snapshot()
      self.appendMainSectionIfNeeded(&snapshot)
      snapshot.appendItems(identifiers, toSection: Section.main)
      self.friendsGardenListDataSource.apply(snapshot)
    }
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func setup () {
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
    self.friendListView.usingAutolayout()
    self.friendListView.equalToParent()
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
    
    return DataSource(collectionView: self.friendListView) { collectionView, indexPath, identifier in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
    }
  }
  
  private func appendMainSectionIfNeeded(_ snapshot: inout Snapshot) {
    if snapshot.sectionIdentifiers.contains(Section.main) == false {
      snapshot.appendSections([Section.main])
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
      collectionView.deselectItem(at: indexPath, animated: true)
    } else {
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    return false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y <= CGFloat.zero {
      self.hideGradientLayerIfNeeded()
    } else {
      self.showGradientLayerOnTopIfNeeded()
    }
  }
}

// MARK: - Gradient layer

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func showGradientLayerOnTopIfNeeded() {
    guard self.gradientLayer.isHidden
    else { return }
    
    self.gradientLayer.isHidden = false
  }
  
  private func hideGradientLayerIfNeeded() {
    guard self.gradientLayer.isHidden == false
    else { return }
    
    self.gradientLayer.isHidden = true
  }
  
  private func addGradientLayerIfNeeded() {
    guard self.bounds.width != CGFloat.zero,
      self.isGradientLayerAdded == false
    else { return }
    
    self.gradientLayer.frame = CGRect(
      x: CGFloat.zero,
      y: CGFloat.zero,
      width: self.bounds.width,
      height: Self.layoutConstant.gradientLayerHeight
    )
    self.layer.addSublayer(self.gradientLayer)
  }
}
