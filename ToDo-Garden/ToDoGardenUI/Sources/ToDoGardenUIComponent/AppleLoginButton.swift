import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AppleLoginButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupButton()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError()
  }
  
  private func setupButton() {
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return AppleLoginButton()
}
#endif
