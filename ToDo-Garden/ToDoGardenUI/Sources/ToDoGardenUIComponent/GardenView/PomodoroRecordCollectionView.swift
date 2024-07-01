//
//  PomodoroRecordCollectionView.swift
//
//
//  Created by Noah on 6/8/24.
//

import UIKit

import ToDoGardenUIConstant

final class PomodoroRecordCollectionView: UICollectionView {
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
