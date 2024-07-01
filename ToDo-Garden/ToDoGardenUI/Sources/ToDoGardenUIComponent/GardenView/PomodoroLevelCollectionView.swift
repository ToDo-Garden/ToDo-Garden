//
//  PomodoroLevelCollectionView.swift
//
//
//  Created by Noah on 6/6/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class PomodoroLevelCollectionView: UICollectionView {
  private var pomodoroLevelCollectionViewDataSource: DataSource?
  
  init() {
    super.init(
      frame: CGRect.zero,
      collectionViewLayout: Self.makePomodoroLevelCollectionViewLayout()
    )
    self.setup()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with pomodoroLevels: [PomodoroLevel]) {
    var snapshot = Snapshot()
    snapshot.appendSections([Section.main])
    let pomodoroLevelCellItems = pomodoroLevels.map { PomodoroLevelCellItem(pomodoroLevel: $0) }
    snapshot.appendItems(pomodoroLevelCellItems)
    self.pomodoroLevelCollectionViewDataSource?.apply(snapshot)
  }
}

// MARK: - Setup

extension PomodoroLevelCollectionView {
  private func setup() {
    self.setupViewAppearance()
    self.setupDataSource()
  }
  
  private func setupViewAppearance() {
    self.backgroundColor = UIColor.clear
  }
  
  private func setupDataSource() {
    self.pomodoroLevelCollectionViewDataSource = self.makeDataSource()
  }
}

extension PomodoroLevelCollectionView {
  private static func makePomodoroLevelCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = Self.makeItemSize()
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = Self.makeGroupSize()
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitems: [item]
    )
    group.interItemSpacing = NSCollectionLayoutSpacing.flexible(
      Constant.PomodoroLevelCollectionView.Layout.Group.interItemSpacing
    )
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
  
  private static func makeItemSize() -> NSCollectionLayoutSize {
    let itemWidthFraction: CGFloat = Constant.PomodoroLevelCollectionView.Layout.Item.widthFraction
    let itemHeightFraction: CGFloat = Constant.PomodoroLevelCollectionView.Layout.Item.heightFraction
    
    return NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(itemWidthFraction),
      heightDimension: NSCollectionLayoutDimension.fractionalWidth(itemHeightFraction)
    )
  }
  
  private static func makeGroupSize() -> NSCollectionLayoutSize {
    let groupWidthFraction: CGFloat = Constant.PomodoroLevelCollectionView.Layout.Group.widthFraction
    let groupHeightFraction: CGFloat = Constant.PomodoroLevelCollectionView.Layout.Group.heightFraction
    
    return NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(groupWidthFraction),
      heightDimension: NSCollectionLayoutDimension.fractionalHeight(groupHeightFraction)
    )
  }
}

extension PomodoroLevelCollectionView {
  private func makeDataSource() -> DataSource {
    let cellRegistration = self.createPomodoroLevelCollectionViewCellRegistration()
    
    return DataSource(collectionView: self) { pomodoroLevelsCollectionView, indexPath, pomodoroLevelItem in
      let pomodoroLevelCollectionViewCell = pomodoroLevelsCollectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: pomodoroLevelItem.pomodoroLevel
      )
      
      return pomodoroLevelCollectionViewCell
    }
  }
  
  private func createPomodoroLevelCollectionViewCellRegistration() -> CellRegistration {
    return CellRegistration { pomodoroLevelCollectionViewCell, _, pomodoroLevel in
      pomodoroLevelCollectionViewCell.configure(with: pomodoroLevel)
    }
  }
}

extension PomodoroLevelCollectionView {
  private enum Section {
    case main
  }
  private typealias CellRegistration =
  UICollectionView.CellRegistration<PomodoroLevelCollectionViewCell, PomodoroLevel>
  private typealias Snapshot =
  NSDiffableDataSourceSnapshot<PomodoroLevelCollectionView.Section, PomodoroLevelCellItem>
  private typealias DataSource =
  UICollectionViewDiffableDataSource<PomodoroLevelCollectionView.Section, PomodoroLevelCellItem>
}
