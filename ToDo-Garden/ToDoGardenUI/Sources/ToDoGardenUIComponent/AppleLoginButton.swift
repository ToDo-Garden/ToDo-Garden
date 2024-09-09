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
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: Constant.AppleLoginButton.width,
      height: Constant.AppleLoginButton.height
    )
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
