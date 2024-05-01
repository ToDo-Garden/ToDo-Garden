import Combine
import UIKit

public class TableRow: UITableViewCell {
  public func build(
    configuration: Styled.Row.Configuration,
    handler: @escaping ((Styled.Row.Configuration) -> Void) = { _ in }
  ) -> AnyCancellable {
    selectionStyle = .none
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
      .sink(receiveValue: handler)
  }
}
