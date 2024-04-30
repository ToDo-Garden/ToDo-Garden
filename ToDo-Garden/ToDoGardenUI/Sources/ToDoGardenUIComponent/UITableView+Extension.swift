import UIKit

public protocol ReusableIdentifier: AnyObject {
  static var identifier: String { get }
}

extension ReusableIdentifier {
  public static var identifier: String {
    String(describing: self)
  }
}

extension UITableViewCell: ReusableIdentifier { }

extension UITableView {
  public func register<T: ReusableIdentifier>(type: T.Type) {
    self.register(type, forCellReuseIdentifier: T.identifier)
  }
  
  public func dequeueReusableCell<T: ReusableIdentifier>(
    type: T.Type,
    for indexPath: IndexPath
  ) -> T? {
    guard
      let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    else { return nil }
    return cell
  }
}
