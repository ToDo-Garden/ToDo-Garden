import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AppleLoginButton: UIButton {
  private let appleLogo: UIImageView
  
  public override init(frame: CGRect) {
    self.appleLogo = UIImageView(image: UIImage.appleLogo)
    super.init(frame: frame)
    self.setupButton()
    self.setupAppleLogo()
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
  
  private func setupButton() {
    self.configureAppearance()
    self.addAction(UIAction { [weak self] _ in
      self?.highlightOn()
    }, for: UIControl.Event.touchDown)
    self.addAction(UIAction { [weak self] _ in
      self?.highlightOn()
    }, for: UIControl.Event.touchDragEnter)
    self.addAction(UIAction { [weak self] _ in
      self?.highlightOff()
    }, for: UIControl.Event.touchUpInside)
    self.addAction(UIAction { [weak self] _ in
      self?.highlightOff()
    }, for: UIControl.Event.touchDragExit)
  }
  
  private func configureAppearance() {
    self.backgroundColor = UIColor.black
    self.layer.cornerRadius = Constant.AppleLoginButton.cornerRadius
    self.clipsToBounds = true
    
    let attributedTitle = self.createAttributedButtonTitle(with: Constant.AppleLoginButton.StringLiteral.title)
    self.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
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
  
  private func setupAppleLogo() {
    guard let titleLabel = self.titleLabel else {
      return
    }
    
    self.appleLogo.contentMode = UIView.ContentMode.scaleAspectFit
    self.appleLogo.usingAutolayout()
    self.addSubview(self.appleLogo)
    
    NSLayoutConstraint.activate([
      self.appleLogo.trailingAnchor.constraint(
        equalTo: titleLabel.leadingAnchor,
        constant: Constant.AppleLoginButton.AppleLogo.trailing
      ),
      self.appleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.appleLogo.widthAnchor.constraint(
        equalToConstant: Constant.AppleLoginButton.AppleLogo.width
      ),
      self.appleLogo.heightAnchor.constraint(
        equalToConstant: Constant.AppleLoginButton.height
      )
    ])
  }
  
  private func highlightOn() {
    UIView.animate(withDuration: 0.3) {
      self.titleLabel?.alpha = 0.5
      self.appleLogo.alpha = 0.5
    }
  }
  
  private func highlightOff() {
    UIView.animate(withDuration: 0.3) {
      self.titleLabel?.alpha = 1.0
      self.appleLogo.alpha = 1.0
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return AppleLoginButton()
}
#endif
