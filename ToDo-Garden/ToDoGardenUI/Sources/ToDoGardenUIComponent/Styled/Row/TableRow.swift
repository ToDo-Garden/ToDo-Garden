import Combine
import UIKit

public class TableRow: UITableViewCell {
  private let row: Styled.Row
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.row = Styled.Row(
      configuration: .profile(
        .init(
          style: .searchRow,
          title: "",
          description: ""
        )
      )
    )
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupRow()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func update(configuration: Styled.Row.Configuration) {
    self.row.configuration = configuration
  }
  
  public func build<T>(
    configuration: Styled.Row.Configuration,
    keyPath: KeyPath<Styled.Row.Configuration, T>
  ) -> AnyPublisher<T, Never>? {
    return self.row.$configuration
      .map(keyPath)
      .eraseToAnyPublisher()
  }
  
  private func setupRow() {
    self.row.usingAutolayout()
    self.contentView.addSubview(self.row)
    
    NSLayoutConstraint.activate(
      [
        self.row.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        self.row.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
        self.row.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        self.row.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
      ]
    )
    
    self.selectionStyle = UITableViewCell.SelectionStyle.none
  }
}

@available(iOS 17.0, *)
#Preview {
  let tableRow = TableRow()
  tableRow.update(
    configuration: .profile(
      .init(
        style: .searchRow,
        title: "searchRow",
        description: "@userID"
      )
    )
  )
  
  return tableRow
}
