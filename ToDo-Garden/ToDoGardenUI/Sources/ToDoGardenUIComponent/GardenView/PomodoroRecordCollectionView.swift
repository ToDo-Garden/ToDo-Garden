//
//  PomodoroRecordCollectionView.swift
//
//
//  Created by Noah on 6/8/24.
//

import UIKit

import ToDoGardenUIConstant

final class PomodoroRecordCollectionView: UICollectionView {
  private var gardenRecordCollectionViewDataSource: DataSource?
  
  init() {
    super.init(
      frame: CGRect.zero,
      collectionViewLayout: Self.makeGardenRecordCollectionViewLayout()
    )
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with pomodoroRecordCellItems: [PomodoroRecordCellItem]) {
    var snapshot = Snapshot()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(pomodoroRecordCellItems)
    self.gardenRecordCollectionViewDataSource?.apply(snapshot)
  }
}

// MARK: - Setup

extension PomodoroRecordCollectionView {
  private func setup() {
    self.setupDataSource()
  }
  
  private func setupDataSource() {
    self.gardenRecordCollectionViewDataSource = self.makeDataSource()
  }
}

// MARK: - Setup layout

extension PomodoroRecordCollectionView {
  private static func makeGardenRecordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = Self.makeItemSize()
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = Self.makeGroupSize()
    var group: NSCollectionLayoutGroup
    group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    group.interItemSpacing = NSCollectionLayoutSpacing.flexible(
      Constant.PomodoroRecordCollectionView.Layout.Group.interItemSpacing
    )
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
  
  private static func makeItemSize() -> NSCollectionLayoutSize {
    let itemWidthFraction: CGFloat = Constant.PomodoroRecordCollectionView.Layout.Item.widthFraction
    let itemHeightFraction: CGFloat = Constant.PomodoroRecordCollectionView.Layout.Item.heightFraction
    
    return NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(itemWidthFraction),
      heightDimension: NSCollectionLayoutDimension.fractionalHeight(itemHeightFraction)
    )
  }
  
  private static func makeGroupSize() -> NSCollectionLayoutSize {
    let groupWidthFraction: CGFloat = Constant.PomodoroRecordCollectionView.Layout.Group.widthFraction
    let groupHeightFraction: CGFloat = Constant.PomodoroRecordCollectionView.Layout.Group.heightFraction
    
    return NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(groupWidthFraction),
      heightDimension: NSCollectionLayoutDimension.fractionalHeight(groupHeightFraction)
    )
  }
}

// MARK: - Setup data source

extension PomodoroRecordCollectionView {
  private func makeDataSource() -> DataSource {
    let pomodoroCollectionViewCellRegistration = self.pomodoroRecordCollectionViewCellRegistration()
    
    return DataSource(collectionView: self) { pomodoroRecordCollectionView, indexPath, pomodoroRecordItem in
      let pomodoroRecordCollectionViewCell = pomodoroRecordCollectionView.dequeueConfiguredReusableCell(
        using: pomodoroCollectionViewCellRegistration,
        for: indexPath,
        item: pomodoroRecordItem
      )
      
      return pomodoroRecordCollectionViewCell
    }
  }
  
  private func pomodoroRecordCollectionViewCellRegistration() -> CellRegistration {
    return CellRegistration { pomodoroRecordCollectionViewCell, _, pomodoroRecordItem in
      pomodoroRecordCollectionViewCell.configure(with: pomodoroRecordItem)
    }
  }
}

extension PomodoroRecordCollectionView {
  private enum Section {
    case main
  }
  
  private typealias CellRegistration =
  UICollectionView.CellRegistration<PomodoroRecordCollectionViewCell, PomodoroRecordCellItem>
  private typealias Snapshot =
  NSDiffableDataSourceSnapshot<PomodoroRecordCollectionView.Section, PomodoroRecordCellItem>
  private typealias DataSource =
  UICollectionViewDiffableDataSource<PomodoroRecordCollectionView.Section, PomodoroRecordCellItem>
}
