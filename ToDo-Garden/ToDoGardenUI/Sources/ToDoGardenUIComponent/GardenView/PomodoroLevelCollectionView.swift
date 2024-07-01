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
    self.setup()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup

extension PomodoroLevelCollectionView {
  private func setup() {
    self.setupDataSource()
  }
  
  private func setupDataSource() {
    self.pomodoroLevelCollectionViewDataSource = self.makeDataSource()
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
