import Foundation

public protocol ReusableIdentifier: AnyObject {
  static var identifier: String { get }
}

extension ReusableIdentifier {
  public static var identifier: String {
    String(describing: self)
  }
}
