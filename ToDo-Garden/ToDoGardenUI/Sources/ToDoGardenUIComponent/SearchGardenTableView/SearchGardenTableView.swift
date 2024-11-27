//
//  SearchGardenTableView.swift
//
//
//  Created by SONG on 11/23/24.
//

import UIKit

final public class SearchGardenTableView: UITableView {
  private var diffableDataSource: UITableViewDiffableDataSource<SearchGardenSection, SearchGardenUser>!
  
  public override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.configureDataSource()
    self.register(TableRow.self, forCellReuseIdentifier: TableRow.identifier)
    self.separatorStyle = UITableViewCell.SeparatorStyle.none
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func updateData(with users: [SearchGardenUser]) {
    var snapshot = NSDiffableDataSourceSnapshot<SearchGardenSection, SearchGardenUser>()
    snapshot.appendSections([SearchGardenSection.main])
    snapshot.appendItems(users)
    self.diffableDataSource.apply(snapshot, animatingDifferences: true)
  }
  
  public func userForCell(at indexPath: IndexPath) -> SearchGardenUser? {
    return self.diffableDataSource.itemIdentifier(for: indexPath)
  }
  
  private func configureDataSource() {
    self.diffableDataSource = UITableViewDiffableDataSource<
      SearchGardenSection,
      SearchGardenUser
    >(tableView: self) { (tableView, indexPath, userData) -> TableRow? in
      guard let tableRow = tableView.dequeueReusableCell(
        withIdentifier: TableRow.identifier,
        for: indexPath
      ) as? TableRow else {
        return nil
      }
      
      tableRow.update(
        configuration: Styled.Row.Configuration.profile(
          .init(
            style: .searchRow,
            title: userData.userNickname,
            description: "@" + userData.userID,
            image: userData.userImage
          )
        )
      )

      return tableRow
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
  
  view.updateData(
    with: [
      SearchGardenUser(userNickname: "흥민갓", userID: "hmzzang123", userImage: nil),
      SearchGardenUser(userNickname: "인성맨", userID: "nomercy", userImage: nil),
      SearchGardenUser(userNickname: "흥민갓", userID: "missyouharrykane", userImage: nil),
      SearchGardenUser(userNickname: "초절정꽃미남", userID: "mrhandsome", userImage: nil)
    ]
  )
  return view
}
#endif
