//
//  CalendarViewDelegate.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

final class CalendarViewDelegate: NSObject {
  private var collectionView: UICollectionView
  private var collectionViewDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>!
  private var dateFormatter: DateFormatter

  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    self.dateFormatter = DateFormatter()
  }
}

extension CalendarViewDelegate {
  private func setupDateFormatter() {
    if let userPreferredIdentifier = Locale.preferredLanguages.first {
      let userLocale = Locale(identifier: userPreferredIdentifier)
      self.dateFormatter.locale = userLocale
    } else {
      self.dateFormatter.locale = Locale.autoupdatingCurrent
    }
    self.dateFormatter.dateFormat = Constant.CalendarView.StringLiteral.dateFormat
  }
}

// MARK: Diffable DataSource

extension CalendarViewDelegate {
  private func setupCollectionViewDataSource() {
    self.collectionViewDataSource = self.makeDiffableDataSource(self.collectionView, with: self.dateFormatter)
    self.collectionView.dataSource = self.collectionViewDataSource
  }
}
