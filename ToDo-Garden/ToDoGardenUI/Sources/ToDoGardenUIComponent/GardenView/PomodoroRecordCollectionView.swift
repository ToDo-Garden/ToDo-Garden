//
//  PomodoroRecordCollectionView.swift
//
//
//  Created by Noah on 6/8/24.
//

import UIKit

import ToDoGardenUIConstant

final class PomodoroRecordCollectionView: UICollectionView {
  
  init() {
    super.init(
      frame: CGRect.zero,
      collectionViewLayout: Self.makeGardenRecordCollectionViewLayout()
    )
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
