import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AppleLoginButton: UIButton {
  private var glowLayer: CALayer?
  
  public override init(frame: CGRect) {
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
    self.configureAppearance()
    self.addAppleLogo()
    self.setupGlowEffect()
    self.addAction(UIAction { [weak self] _ in
      self?.buttonTouchDown()
    }, for: UIControl.Event.touchDown)
    self.addAction(UIAction { [weak self] _ in
      self?.buttonTouchUpInside()
    }, for: UIControl.Event.touchUpInside)
    self.addAction(UIAction { [weak self] _ in
      self?.buttonTouchDragExit()
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
  
  private func addAppleLogo() {
    guard let titleLabel = self.titleLabel else {
      return
    }
    
    let appleLogo = self.createAppleLogo()
    self.addSubview(appleLogo)
    
    NSLayoutConstraint.activate([
      appleLogo.trailingAnchor.constraint(
        equalTo: titleLabel.leadingAnchor,
        constant: Constant.AppleLoginButton.AppleLogo.trailing
      ),
      appleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      appleLogo.widthAnchor.constraint(
        equalToConstant: Constant.AppleLoginButton.AppleLogo.width
      ),
      appleLogo.heightAnchor.constraint(
        equalToConstant: Constant.AppleLoginButton.height
      )
    ])
  }
  
  private func createAppleLogo() -> UIImageView {
    let imageView = UIImageView(image: UIImage.appleLogo)
    imageView.contentMode = UIView.ContentMode.scaleAspectFit
    imageView.usingAutolayout()
    return imageView
  }
  
  private func setupGlowEffect() {
    self.glowLayer = CALayer()
    self.glowLayer?.backgroundColor = UIColor.white.cgColor
    self.glowLayer?.opacity = 0
    self.glowLayer?.cornerRadius = Constant.AppleLoginButton.cornerRadius
    
    if let glowLayer = self.glowLayer {
      self.layer.addSublayer(glowLayer)
    }
  }
  
  private func buttonTouchDown() {
    UIView.animate(withDuration: 0.1) {
      self.glowLayer?.opacity = 0.5
    }
  }
  
  private func buttonTouchUpInside() {
    self.fadeOutGlowEffect()
  }
  
  private func buttonTouchDragExit() {
    self.fadeOutGlowEffect()
  }
  
  private func fadeOutGlowEffect() {
    UIView.animate(withDuration: 0.5, animations: {
      self.glowLayer?.opacity = 0
    })
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.glowLayer?.frame = self.bounds
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return AppleLoginButton()
}
#endif
