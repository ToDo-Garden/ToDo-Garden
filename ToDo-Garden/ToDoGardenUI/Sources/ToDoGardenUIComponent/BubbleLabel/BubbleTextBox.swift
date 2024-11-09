//
//  BubbleTextBox.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import TDUtility
import ToDoGardenUIConstant
import ToDoGardenUIResource

final class BubbleTextBox: UIView {
  private let textLabel: UILabel
  let cancelButton: UIButton
  
  init(iconImage: UIImage, text: String) {
    self.textLabel = UILabel()
    self.cancelButton = UIButton()
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.toDoGardenGreenDark.cgColor
    self.setupView(iconImage: iconImage, text: text)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    let verticalMargin = Constant.BubbleLabel.BubbleTextBox.commonMargin
    return CGSize(
      width: UIView.noIntrinsicMetric,
      height: self.textLabel.intrinsicContentSize.height + verticalMargin
    )
  }
  
  private func setupView(iconImage: UIImage, text: String) {
    self.setupTextLabel(iconImage: iconImage, text: text)
    self.setupCancelButton()
    self.setupConstraints()
  }
  
  private func setupTextLabel(iconImage: UIImage, text: String) {
    let length = Constant.BubbleLabel.BubbleTextBox.iconLength
    let targetSize = CGSize(width: length, height: length)
    
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = iconImage.resizedImage(targetSize: targetSize)
    let stringWithImage = NSMutableAttributedString(attachment: imageAttachment)
    
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttributes([
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: Constant.BubbleLabel.BubbleTextBox.fontSize,
        weight: UIFont.Weight.bold
      ),
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
    ], range: NSRange(location: Int.zero, length: attributedString.length))
    
    stringWithImage.append(
      NSAttributedString(string: Constant.BubbleLabel.BubbleTextBox.singleSpace)
    )
    stringWithImage.append(attributedString)
    
    self.textLabel.attributedText = stringWithImage
    self.textLabel.numberOfLines = Int.zero
    self.textLabel.usingAutolayout()
    self.addSubview(self.textLabel)
  }
  
  private func setupCancelButton() {
    self.cancelButton.setImage(UIImage.xMark, for: .normal)
    self.cancelButton.usingAutolayout()
    self.cancelButton.tintColor = UIColor.toDoGardenGreenDark
    self.addSubview(self.cancelButton)
  }
  
  private func setupConstraints() {
    let margin = Constant.BubbleLabel.BubbleTextBox.commonMargin
    let cancelButtonLength = Constant.BubbleLabel.BubbleTextBox.cancelButtonLength
    
    NSLayoutConstraint.activate([
      self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
      self.textLabel.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor, constant: -(margin / 2)),
      self.textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: (margin / 2)),
      self.textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(margin / 2) - 1.0),
      
      self.cancelButton.widthAnchor.constraint(equalToConstant: cancelButtonLength),
      self.cancelButton.heightAnchor.constraint(equalToConstant: cancelButtonLength),
      self.cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
      self.cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    
    self.layer.cornerRadius = cancelButtonLength
  }
}
