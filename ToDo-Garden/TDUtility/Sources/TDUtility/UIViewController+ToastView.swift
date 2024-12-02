//
//  UIViewController+ToastView.swift
//  TDUtility
//
//  Created by SONG on 11/30/24.
//

import UIKit

public extension UIViewController {
  func showToast(
    message: String,
    backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7),
    textColor: UIColor = UIColor.white
  ) {
    let toastView = self.getToastView(message: message, backgroundColor: backgroundColor, textColor: textColor)
    self.view.addSubview(toastView)
    self.setupToastViewConstraints(toastView: toastView)
    toastView.animateToastView()
  }
  
  private func getToastView(message: String, backgroundColor: UIColor, textColor: UIColor) -> ToastView {
    if let existingToastView = self.view.subviews.first(where: { $0 is ToastView }) as? ToastView {
      existingToastView.messageLabel.text = message
      existingToastView.backgroundColor = backgroundColor
      existingToastView.alpha = 0.0
      return existingToastView
    } else {
      return ToastView(message: message, backgroundColor: backgroundColor, textColor: textColor)
    }
  }
  
  private func setupToastViewConstraints(toastView: ToastView) {
    toastView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      toastView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      toastView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
      toastView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20)
    ])
  }
}

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
  
  func animateToastView() {
    UIView.animate(
      withDuration: 0.3,
      animations: {
        self.alpha = 1.0
      },
      completion: { _ in
        UIView.animate(
          withDuration: 0.3,
          delay: 2.0,
          options: [],
          animations: {
            self.alpha = 0.0
          }
        )
      }
    )
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
