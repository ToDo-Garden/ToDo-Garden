import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AppleLoginButton: UIButton {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.configuration = UIButton.Configuration.plain()
    self.configureAppearance()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: Constant.AppleLoginButton.width,
      height: Constant.AppleLoginButton.height
    )
  }
  
  override public func updateConfiguration() {
    super.updateConfiguration()
    if self.isHighlighted {
      self.highlightOn()
    } else {
      self.highlightOff()
    }
  }
  
  private func configureAppearance() {
    let constants = Constant.AppleLoginButton.self
    
    self.configuration?.background.backgroundColor = UIColor.toDoGardenBlack
    self.layer.cornerRadius = constants.cornerRadius
    self.clipsToBounds = true
    
    self.configuration?.image = UIImage.appleLogo
    self.configuration?.attributedTitle = AttributedString(
      self.createAttributedButtonTitle(
        with: constants.StringLiteral.title
      )
    )
    self.configuration?.imagePadding = constants.AppleLogo.imagePadding
    self.configuration?.contentInsets = NSDirectionalEdgeInsets(
      top: constants.ContentInsets.vertical,
      leading: constants.ContentInsets.leading,
      bottom: constants.ContentInsets.vertical,
      trailing: constants.ContentInsets.trailing
    )
  }
  
  private func createAttributedButtonTitle(with title: String) -> NSAttributedString {
    return title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(
          ofSize: Constant.AppleLoginButton.fontSize,
          weight: UIFont.Weight.bold
        ),
        NSAttributedString.Key.foregroundColor: UIColor.white
      ]
    )
  }
  
  private func highlightOn() {
    UIView.animate(withDuration: 0.3) {
      self.titleLabel?.alpha = 0.5
      self.imageView?.alpha = 0.5
    }
  }
  
  private func highlightOff() {
    UIView.animate(withDuration: 0.3) {
      self.titleLabel?.alpha = 1.0
      self.imageView?.alpha = 1.0
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return AppleLoginButton()
}
#endif
