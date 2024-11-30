//
//  Untitled.swift
//  TDUtility
//
//  Created by SONG on 11/30/24.
//


final class ToastView: UIView {
  let messageLabel: UILabel
  
  init(
    message: String,
    backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7),
    textColor: UIColor = UIColor.white
  ) {
    self.messageLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.setupView(backgroundColor: backgroundColor)
    self.configureMessageLabel(message: message, textColor: textColor)
    self.setupConstraints()
  }
  
  private func setupView(backgroundColor: UIColor) {
    self.backgroundColor = backgroundColor
    self.alpha = 0.0
    self.layer.cornerRadius = 10
    self.clipsToBounds = true
  }
  
  private func configureMessageLabel(message: String, textColor: UIColor) {
    self.messageLabel.text = message
    self.messageLabel.textColor = textColor
    self.messageLabel.font = UIFont.systemFont(ofSize: 15)
    self.messageLabel.numberOfLines = 0
    self.messageLabel.textAlignment = NSTextAlignment.center
    
    self.addSubview(self.messageLabel)
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      self.messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      self.messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
    ])
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
