//
//  FriendsGardenListView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/23/24.
//

import UIKit

import ShareGardenSceneEntity

extension ShareGardenSceneViewController.FriendsGardenView {
  final class FriendsGardenListView: UIView {
    var isEditing: Bool {
      get {
        return self.friendListView.isEditing
      } set {
        self.friendListView.isEditing = newValue
      }
    }
    
    private lazy var friendsGardenListDataSource: DataSource = self.setupDataSource()
    private lazy var friendListView: UICollectionView = {
      let friendListView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: self.makeFriendsGardenListViewLayout()
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
    private weak var friendsGardenStore: FriendsGardenStore?
    
    init(friendsGardenStore: FriendsGardenStore) {
      self.friendsGardenStore = friendsGardenStore
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    /// FriendsGardenListView에 Shimmering Animation을 적용합니다.
    /// - Parameter numberOfCells: 표시될 placeholder cell의 숫자입니다.
    func startShimmeringAnimation(numberOfCells: Int) {
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
    
    func stopShimmeringAnimation() {
      self.isUserInteractionEnabled = true
      self.friendsGardenListDataSource.apply(Snapshot())
    }
    
    func append(_ identifiers: [ShareGardenScene.FriendsGarden.ID]) {
      var snapshot = self.friendsGardenListDataSource.snapshot()
      if snapshot.sectionIdentifiers.contains(Section.main) == false {
        snapshot.appendSections([Section.main])
      }
      
      let firendsGardens: [ShareGardenScene.FriendsGarden] = identifiers.compactMap {
        return self.friendsGardenStore?.fetch(by: $0)
      }
      let sectionSnapshot = self.makeSectionSnapshot(for: firendsGardens)
      
      self.friendsGardenListDataSource.apply(sectionSnapshot, to: Section.main)
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func makeSectionSnapshot(
    for friendsGardens: [ShareGardenScene.FriendsGarden]
  ) -> NSDiffableDataSourceSectionSnapshot<Item> {
    var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
    
    let friendsGardenItems: [Item] = friendsGardens.map { friendsGarden in
      let item = Item.friendsGarden(
        ShareGardenSceneViewController.FriendsGardenContentConfiguration(
          id: friendsGarden.id,
          pomodoroRecords: friendsGarden.pomodoroRecords
        )
      )
      
      return item
    }
    
    let combined = zip(friendsGardens, friendsGardenItems)
    
    for (friendsGarden, friendsGardenItem) in combined {
      let friendsProfileItem = Item.friendsProfile(
        ShareGardenSceneViewController.FriendsProfileContentConfiguration(
          id: friendsGarden.id,
          friendsGarden: friendsGarden
        )
      )
      sectionSnapshot.append([friendsProfileItem])
      sectionSnapshot.append([friendsGardenItem], to: friendsProfileItem)
    }
    
    return sectionSnapshot
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func setup() {
    self.addSubviews()
    self.setupLayoutConstraints()
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
    case friendsProfile(ShareGardenSceneViewController.FriendsProfileContentConfiguration)
    case friendsGarden(ShareGardenSceneViewController.FriendsGardenContentConfiguration)
    case loading(UUID)
  }
  
  private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
  private typealias FriendsGardenListViewLoadingCell =
  ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewLoadingCell
  private typealias Snapshot =
  NSDiffableDataSourceSnapshot<
    ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView.Section,
    Item
  >
  private typealias FriendsGardenCellRegistration = UICollectionView.CellRegistration<
    UICollectionViewListCell,
    Item
  >
  private typealias LoadingCellRegistration = UICollectionView.CellRegistration<
    FriendsGardenListViewLoadingCell,
    Item
  >
}

// MARK: - layout

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
    guard let indexPath = indexPath,
      let cell = self.friendListView.cellForItem(at: indexPath)?.contentView as? ShareGardenSceneViewController
      .FriendsGardenProfileInfoView,
      cell.isExpanded == false
    else {
      return nil
    }
        
    let deleteAction = UIContextualAction(
      style: UIContextualAction.Style.destructive,
      title: nil
    ) { _, _, _ in
    }
    deleteAction.accessibilityLabel = "Delete"
    deleteAction.image = UIImage(systemName: "trash")
    deleteAction.backgroundColor = UIColor.toDoGardenEditButtonRed
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  private func makeFriendsGardenListViewLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(
      appearance: UICollectionLayoutListConfiguration.Appearance.plain
    )
    listConfiguration.showsSeparators = false
    
    listConfiguration.trailingSwipeActionsConfigurationProvider = self.makeSwipeAction
    listConfiguration.backgroundColor = UIColor.white
    
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
  
  private func setupLayoutConstraints() {
    self.setupFriendListViewLayoutConstraints()
  }
  
  private func setupFriendListViewLayoutConstraints() {
    self.friendListView.equalToParent()
  }
}

// MARK: - Data Source

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView {
  private func makeFriendsGardenProfileCellRegistration() -> FriendsGardenCellRegistration {
    return FriendsGardenCellRegistration { cell, _, item in
      guard case let Item.friendsProfile(configuration) = item
      else { return }
      
      cell.contentConfiguration = configuration
      cell.accessories = [
        UICellAccessory.delete(
          displayed: UICellAccessory.DisplayedState.whenEditing,
          options: UICellAccessory.DeleteOptions(tintColor: UIColor.toDoGardenEditButtonRed)
        )
      ]
     
      cell.backgroundColor = UIColor.white
      let cellBackgroundView = UIView()
      cellBackgroundView.backgroundColor = UIColor.white
      cell.backgroundView = cellBackgroundView
    }
  }
  
  private func makeFriendsGardenCellRegistration() -> FriendsGardenCellRegistration {
    return FriendsGardenCellRegistration { cell, _, item in
      guard case let Item.friendsGarden(configuration) = item
      else { return }
      
      cell.contentConfiguration = configuration
      cell.indentationLevel = Int.zero
    }
  }
  
  private func setupDataSource() -> DataSource {
    let friendsGardenProfileCellRegistration = self.makeFriendsGardenProfileCellRegistration()
    let loadingCellRegistration = LoadingCellRegistration { _, _, _ in }
    let friendsGardenCellRegistration = self.makeFriendsGardenCellRegistration()
    
    return DataSource(collectionView: self.friendListView) { collectionView, indexPath, item in
      switch item {
      case Item.loading:
        return collectionView.dequeueConfiguredReusableCell(
          using: loadingCellRegistration,
          for: indexPath,
          item: item
        )
      case Item.friendsProfile(_):
        return collectionView.dequeueConfiguredReusableCell(
          using: friendsGardenProfileCellRegistration,
          for: indexPath,
          item: item
        )
      case Item.friendsGarden(_):
        return collectionView.dequeueConfiguredReusableCell(
          using: friendsGardenCellRegistration,
          for: indexPath,
          item: item
        )
      }
    }
  }
  
  func collapseAll() {
    var sectionSnapshot = self.friendsGardenListDataSource.snapshot(for: Section.main)
    sectionSnapshot.items.forEach { item in
      if sectionSnapshot.isExpanded(item) {
        sectionSnapshot.collapse([item])
      }
    }
    self.friendsGardenListDataSource.apply(sectionSnapshot, to: Section.main)
  }
}

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListView: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let isStartPointReached = scrollView.contentOffset.y <= CGFloat.zero
    self.gradientLayer.isHidden = isStartPointReached
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let selectedItem = self.friendsGardenListDataSource.itemIdentifier(for: indexPath) else { return }
    var sectionSnapshot = self.friendsGardenListDataSource.snapshot(for: Section.main)
    
    if sectionSnapshot.isExpanded(selectedItem) {
      sectionSnapshot.collapse([selectedItem])
    } else {
      sectionSnapshot.expand([selectedItem])
    }
    
    self.friendsGardenListDataSource.apply(sectionSnapshot, to: Section.main, animatingDifferences: true)
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
