import Combine
import UIKit

public class TableRow: UITableViewCell {
  private func setupRow(configuration: Styled.Row.Configuration) -> Styled.Row {
    let newRow = Styled.Row(configuration: configuration)
    newRow.usingAutolayout()
    self.contentView.addSubview(newRow)
    
    NSLayoutConstraint.activate([
      newRow.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      newRow.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      newRow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      newRow.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
    
    self.selectionStyle = UITableViewCell.SelectionStyle.none
    return newRow
  }
  
  public func build(configuration: Styled.Row.Configuration) -> Self {
    _ = self.setupRow(configuration: configuration)
    return self
  }
  
  public func build<T>(
    configuration: Styled.Row.Configuration,
    keyPath: KeyPath<Styled.Row.Configuration, T>
  ) -> AnyPublisher<T, Never>? {
    let setupRow = self.setupRow(configuration: configuration)
    return setupRow.$configuration
      .map(keyPath)
      .eraseToAnyPublisher()
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = TableRow().build(
    configuration: .profile(
      .init(
        style: .searchRow,
        title: "searchRow",
        description: "@userID"
      )
    )
  )
  return cell
}
