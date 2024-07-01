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
