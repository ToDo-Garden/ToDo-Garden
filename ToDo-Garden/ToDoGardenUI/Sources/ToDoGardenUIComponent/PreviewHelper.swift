#if DEBUG
import SwiftUI

public struct WrappedView<T: UIView>: UIViewRepresentable {
  let view: () -> T
  
  public init(view: @escaping () -> T) {
    self.view = view
  }
  
  public func makeUIView(context: Context) -> T {
    return view()
  }
  
  public func updateUIView(
    _ uiView: T,
    context: Context
  ) { }
}
#endif
