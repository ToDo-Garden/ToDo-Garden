//
//  SearchGardenTableView.swift
//
//
//  Created by SONG on 11/23/24.
//

import UIKit

final public class SearchGardenTableView: UITableView {
  private var diffableDataSource: UITableViewDiffableDataSource<SearchGardenSection, SearchGardenUser>!
  private var snapshot: NSDiffableDataSourceSnapshot<SearchGardenSection, SearchGardenUser>!
  private var placeHolderData: SearchGardenUser? = SearchGardenUser.placeholderData()

  public override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.configureDataSource()
    self.snapshot = NSDiffableDataSourceSnapshot<SearchGardenSection, SearchGardenUser>()
    self.snapshot.appendSections([SearchGardenSection.main])
    self.backgroundColor = UIColor.white
    self.register(TableRow.self, forCellReuseIdentifier: TableRow.identifier)
    self.separatorStyle = UITableViewCell.SeparatorStyle.none
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func appendData(with users: [SearchGardenUser]) {
    if !self.snapshot.sectionIdentifiers.contains(SearchGardenSection.main) {
      self.snapshot.appendSections([SearchGardenSection.main])
    }
    self.snapshot.appendItems(users)
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
  }
  
  public func clearItemsInMainSection(completion: (() -> Void)? = nil) {
    self.snapshot.deleteItems(snapshot.itemIdentifiers(inSection: SearchGardenSection.main))
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
    completion?()
  }
  
  public func cleanUpDeinit() {
    self.placeHolderData = nil
    self.snapshot = NSDiffableDataSourceSnapshot<SearchGardenSection, SearchGardenUser>()
    self.snapshot.appendSections([.main])
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
  }
  
  public func userForCell(at indexPath: IndexPath) -> SearchGardenUser? {
    return self.diffableDataSource.itemIdentifier(for: indexPath)
  }
  
  public func updateData(of user: [SearchGardenUser]) {
    let currentItems = Set(snapshot.itemIdentifiers)
    let validUsers = user.filter { currentItems.contains($0) }
    
    self.snapshot.reconfigureItems(validUsers)
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
  }
  
  public func appendPlaceholderCell() {
    guard let placeHolderData = self.placeHolderData else { return }
    self.snapshot.appendItems([placeHolderData])
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
  }
  
  public func deletePlaceholderCell() {
    guard let placeHolderData = self.placeHolderData else { return }
    guard self.snapshot.itemIdentifiers.contains(placeHolderData) else {
      return
    }
    
    self.snapshot.deleteItems([placeHolderData])
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
  }
  
  private func configureDataSource() {
    self.diffableDataSource = UITableViewDiffableDataSource<
      SearchGardenSection,
      SearchGardenUser
    >(tableView: self) { [weak self] (tableView, indexPath, userData) -> TableRow? in
      guard let self = self,
        let tableRow = tableView.dequeueReusableCell(
        withIdentifier: TableRow.identifier,
        for: indexPath
      ) as? TableRow else {
        return nil
      }

      self.diffableDataSource.defaultRowAnimation = UITableView.RowAnimation.fade
      self.updateTableRow(userData: userData, tableRow: tableRow)
      self.setDummyOrNot(userData: userData, tableRow: tableRow)
      return tableRow
    }
  }
  
  private func updateTableRow(userData: SearchGardenUser, tableRow: TableRow) {
    tableRow.update(
      configuration: Styled.Row.Configuration.profile(
        .init(
          style: .searchRow,
          title: userData.nickname,
          description: "@" + userData.customId,
          image: userData.userImage
        )
      )
    )
  }
  
  private func setDummyOrNot(userData: SearchGardenUser, tableRow: TableRow) {
    if userData.isDummyData {
      tableRow.contentView.subviews.forEach { $0.isShimmering = true }
      tableRow.contentView.startShimmering()
      tableRow.isUserInteractionEnabled = false
    } else {
      tableRow.contentView.stopShimmering()
      tableRow.isUserInteractionEnabled = true
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = SearchGardenTableView(frame: CGRect.zero, style: UITableView.Style.plain)
  view.usingAutolayout()
  NSLayoutConstraint.activate([
    view.widthAnchor.constraint(equalToConstant: 370),
    view.heightAnchor.constraint(equalToConstant: 700)
  ])
  
  view.appendData(
    with: [
      SearchGardenUser(
        id: UUID(),
        nickname: "흥민갓",
        customId: "hmzzang123",
        userImage: nil,
        userImageURL: nil
      )
    ]
  )
  return view
}
#endif
