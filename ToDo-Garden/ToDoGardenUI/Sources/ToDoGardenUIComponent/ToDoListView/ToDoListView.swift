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
  
  var contentInset: UIEdgeInsets {
    get {
      return self.contentView.contentInset
    } set {
      self.contentView.contentInset = newValue
    }
  }
  
  private lazy var dataSource: DataSource = self.makeDataSource()
  
  public weak var buttonActionDelegate: ToDoListButtonActionDelegate?
  public weak var cellUpdatingDelegate: ToDoListViewCellUpdatingDelegate?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func apply(_ snapshot: Snapshot, completion: (() -> Void)? = nil) {
    self.dataSource.apply(snapshot, completion: completion)
  }
  
  public func applyWithReloadData(_ snapshot: Snapshot, completion: (() -> Void)? = nil) {
    self.dataSource.applySnapshotUsingReloadData(snapshot, completion: completion)
  }
  
  public func getSnapShot() -> Snapshot {
    return self.dataSource.snapshot()
  }
  
  public func updateHeaderUIAfterUpdatingToDo(section: ToDoSection) {
    let newProgressRate = self.calculateProgressRate(for: section)
    
    guard let headerView = self.contentView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: 0, section: self.getSectionIndex(for: section))
    ) as? ToDoGroupSectionHeaderView else { return }
    
    let updatedModel = section.headerUIModel
    updatedModel.updateProgressRate(newProgressRate)
    headerView.update(with: updatedModel)
  }
}

// MARK: - Setup

extension ToDoListView {
  private func setup() {
    self.setupLayout()
  }
}

// MARK: - DataSource
// swiftlint: disable all
extension ToDoListView {
  private func makeDataSource() -> DataSource {
    let toDoCellRegistration = ToDoCellRegistration { cell, _, toDoItem in
      cell.contentConfiguration = ToDoContentViewContentConfiguration(model: toDoItem.toDoUIModel)
      cell.indentationLevel = Int.zero

      toDoItem.toDoUIModel.isSelected.bind { [weak self] bool in
        guard let self = self,
          let currentIndexPath = self.getCurrentIndexPath(for: toDoItem)
        else { return }
        
        self.cellUpdatingDelegate?.updateSelection(isSelected: bool, todo: toDoItem, at: currentIndexPath)
        
        Task { @MainActor in
          await self.updateHeaderUI(indexPath: currentIndexPath)
        }
      }
      
      toDoItem.toDoUIModel.text.bind { [weak self] text in
        guard let self = self,
          let currentIndexPath = self.getCurrentIndexPath(for: toDoItem)
        else { return }
        
        self.cellUpdatingDelegate?.updateText(text: text, todo: toDoItem, at: currentIndexPath)
      }
    }
    
    let toDoGroupHeaderRegistration = ToDoGroupHeaderRegistration(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { supplementaryView, _, indexPath in
      let snapshot = self.dataSource.snapshot()
      let section = snapshot.sectionIdentifiers[indexPath.section]
      
      supplementaryView.update(with: section.headerUIModel)
      supplementaryView.section = indexPath.section
      supplementaryView.delegate = self
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
    listConfiguration.trailingSwipeActionsConfigurationProvider = { [weak self] in
      self?.makeSwipeAction(for: $0)
    }
    
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
  
  private func makeSwipeAction(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard let todo = self.getItemForIndexPath(indexPath),
      let group = self.getGroupForIndexPath(indexPath)
    else { return nil }
    
    let deleteAction = UIContextualAction(
      style: UIContextualAction.Style.destructive,
      title: nil
    ) { _, _, _ in
      self.buttonActionDelegate?.didDeleteButtonTapped(group: group, todo: todo)
    }
    deleteAction.accessibilityLabel = "Delete"
    deleteAction.image = UIImage.deleteIconImage
    deleteAction.backgroundColor = UIColor.toDoGardenEditButtonRed
    
    let editAction = UIContextualAction(
      style: UIContextualAction.Style.normal,
      title: nil
    ) { _, _, _ in
      self.buttonActionDelegate?.didEditButtonTapped(group: group, todo: todo)
    }
    editAction.accessibilityLabel = "Edit"
    editAction.image = UIImage.editIconImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    editAction.backgroundColor = UIColor.toDoGardenEditButtonOrange
    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
  }
}

extension ToDoListView {
  public func getToDoListGroup() -> UIView {
    return self.contentView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: 0, section: 0)
    ) ?? UIView()
  }
  
  public func getToDoListToDo() -> UIView {
    guard let cell = self.contentView.cellForItem(at: IndexPath(item: 0, section: 0)) else { return UIView()}
    return cell
  }
  
  private func getItemForIndexPath(_ indexPath: IndexPath) -> ToDoItem? {
    let snapshot = self.dataSource.snapshot()
    guard indexPath.section < snapshot.sectionIdentifiers.count else {
      return nil
    }
    
    return snapshot.sectionIdentifiers[indexPath.section].toDoItems[indexPath.item]
  }
  
  private func getGroupForIndexPath(_ indexPath: IndexPath) -> ToDoSection? {
    let snapshot = self.dataSource.snapshot()
    guard indexPath.section < snapshot.sectionIdentifiers.count else {
      return nil
    }
    
    return snapshot.sectionIdentifiers[indexPath.section]
  }
}

extension ToDoListView: ToDoGroupSectionHeaderViewDelegate {
  func createToDo(in section: Int) {
    guard let group = self.getGroupForIndexPath(IndexPath(item: 0, section: section)) else { return }
    
    self.buttonActionDelegate?.didCreateToDoButtonTapped(group: group)
  }
  
  func goTimer(in section: Int) {
    guard let group = self.getGroupForIndexPath(IndexPath(item: 0, section: section)) else { return }
    
    self.buttonActionDelegate?.didTimerButtonTapped(group: group)
  }
  
  private func updateHeaderUI(indexPath: IndexPath) async {
    guard let section = self.getSection(for: indexPath) else { return }
    
    let newProgressRate = self.calculateProgressRate(for: section)

    guard let headerView = self.contentView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: 0, section: indexPath.section)
    ) as? ToDoGroupSectionHeaderView else {
      return
    }

    let updatedModel = section.headerUIModel
    updatedModel.updateProgressRate(newProgressRate)
    headerView.update(with: updatedModel)
  }
  
  private func getSection(for indexPath: IndexPath) -> ToDoSection? {
    let snapshot = self.dataSource.snapshot()
    let section = snapshot.sectionIdentifiers[indexPath.section]
    return section
  }
  
  private func calculateProgressRate(for section: ToDoSection) -> CGFloat {
    let selected = section.toDoItems.filter { item in
      return item.toDoUIModel.isSelected.value
    }.count
    
    return CGFloat(selected) / CGFloat(section.toDoItems.count)
  }
  
  func getSectionIndex(for section: ToDoSection) -> Int {
    let snapshot = dataSource.snapshot()
    guard let sectionIndex = snapshot.sectionIdentifiers.firstIndex(of: section) else {
      return 0
    }
    
    return sectionIndex
  }
  
  private func getCurrentIndexPath(for item: ToDoItem) -> IndexPath? {
    let snapshot = self.dataSource.snapshot()
    guard let itemIndex = snapshot.itemIdentifiers.firstIndex(of: item) else { return nil }

    guard let sectionIndex = snapshot.sectionIdentifiers.firstIndex(where: { section in
      section.getToDoItems().contains(item)
    }) else { return nil }
    
    return IndexPath(item: itemIndex, section: sectionIndex)
  }
}
// swiftlint: enable all

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
