import Combine
import UIKit

public class TableRow: UITableViewCell {
  public func build<T>(
    configuration: Styled.Row.Configuration,
    keyPath: KeyPath<Styled.Row.Configuration, T>
  ) -> AnyPublisher<T, Never> {
    selectionStyle = UITableViewCell.SelectionStyle.none
    let row = Styled.Row(configuration: configuration)
    row.usingAutolayout()
    contentView.addSubview(row)
    NSLayoutConstraint.activate([
      row.topAnchor.constraint(equalTo: contentView.topAnchor),
      row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
    
    return row.$configutration
      .map(keyPath)
      .eraseToAnyPublisher()
  }
}
