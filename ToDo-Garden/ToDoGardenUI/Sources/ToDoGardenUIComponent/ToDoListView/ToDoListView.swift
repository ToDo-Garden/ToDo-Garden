//
//  ToDoListView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/5/24.
//

import UIKit

// MARK: - Typealias

extension ToDoListView {
  public typealias Snapshot = NSDiffableDataSourceSnapshot<ToDoSection, ToDoListView.ToDoItem>
  public typealias ToDoUIModel = Styled.Row.Configuration.TodoListModel
  private typealias DataSource = UICollectionViewDiffableDataSource<ToDoSection, ToDoItem>
  private typealias ToDoCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ToDoItem>
  private typealias ToDoGroupHeaderRegistration = UICollectionView.SupplementaryRegistration<ToDoGroupSectionHeaderView>
}

public final class ToDoListView: UIView {
  private lazy var contentView: UICollectionView = {
    let toDoListView = UICollectionView(
      frame: CGRect.zero,
      collectionViewLayout: self.makeToDoListViewLayout()
    )
    toDoListView.backgroundColor = UIColor.white
    
    return toDoListView
  }()
  private lazy var dataSource: DataSource = self.makeDataSource()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func apply(_ snapshot: Snapshot) {
    self.dataSource.apply(snapshot)
  }
}

// MARK: - Setup

extension ToDoListView {
  private func setup() {
    self.setupLayout()
  }
}

// MARK: - DataSource

extension ToDoListView {
  private func makeDataSource() -> DataSource {
    let toDoCellRegistration = ToDoCellRegistration { cell, _, toDoItem in
      cell.contentConfiguration = ToDoContentViewContentConfiguration(model: toDoItem.toDoUIModel)
      cell.indentationLevel = Int.zero
    }
    
    let toDoGroupHeaderRegistration = ToDoGroupHeaderRegistration(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { supplementaryView, _, indexPath in
      let snapshot = self.dataSource.snapshot()
      let section = snapshot.sectionIdentifiers[indexPath.section]
      
      supplementaryView.update(with: section.headerUIModel)
    }
    
    let dataSource = DataSource(collectionView: self.contentView) { collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(
        using: toDoCellRegistration,
        for: indexPath,
        item: item
      )
    }
    
    dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
      return collectionView.dequeueConfiguredReusableSupplementary(using: toDoGroupHeaderRegistration, for: indexPath)
    }
    
    return dataSource
  }
}

// MARK: - layout

extension ToDoListView {
  private func setupLayout() {
    self.backgroundColor = UIColor.white
    self.addSubview(self.contentView)
    self.contentView.equalToParent()
  }
  
  private func makeToDoListViewLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(
      appearance: UICollectionLayoutListConfiguration.Appearance.grouped
    )
    listConfiguration.showsSeparators = false
    listConfiguration.backgroundColor = UIColor.white
    listConfiguration.headerMode = UICollectionLayoutListConfiguration.HeaderMode.supplementary
    
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
}

@available(iOS 17.0, *)
#Preview {
  let toDoListView = ToDoListView()
  var snapshot = ToDoListView.Snapshot()
  
  let section1 = ToDoListView.ToDoSection(
    headerUIModel: .init(progressColor: .toDoGardenRed, progressRate: 0.6, groupTitle: "영어독해"),
    toDoItems: [.init(toDoUIModel: .init(text: "프로폴리스", foregroundColor: .toDoGardenRed))]
  )
  
  let section2 = ToDoListView.ToDoSection(
    headerUIModel: .init(progressColor: .toDoGardenYellow, progressRate: 0.6, groupTitle: "영어독해"),
    toDoItems: [
      .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
      .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
      .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
      .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow))
    ]
  )
  
  snapshot.appendSections([section1, section2])
  
  snapshot.sectionIdentifiers.forEach { section in
    snapshot.appendItems(section.toDoItems, toSection: section)
  }
  
  toDoListView.apply(snapshot)
  
  return toDoListView
}
