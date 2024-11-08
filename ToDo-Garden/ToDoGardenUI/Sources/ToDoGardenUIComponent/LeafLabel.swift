//
//  LeafLabel.swift
//
//
//  Created by SONG on 11/8/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class LeafLabel: UIView {
  private let leafImageView: UIImageView
  private let titleLabel: UILabel
  private let descriptionLabel: UILabel
  
  public init(
    titleText: String,
    descriptionText: String
  ) {
    self.leafImageView = UIImageView(image: UIImage.leafImage)
    self.titleLabel = UILabel()
    self.descriptionLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.clear
    self.setupImageView()
    self.setupLabels(
      titleText: titleText,
      descriptionText: descriptionText
    )
    self.setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: UIView.noIntrinsicMetric,
      height: Constant.LeafLabel.height
    )
  }
  
  private func setupImageView() {
    self.leafImageView.usingAutolayout()
    self.leafImageView.contentMode = .scaleAspectFit
    self.addSubview(self.leafImageView)
  }
  
  private func setupLabels(titleText: String, descriptionText: String) {
    self.titleLabel.usingAutolayout()
    self.descriptionLabel.usingAutolayout()
    
    self.titleLabel.numberOfLines = 1
    self.descriptionLabel.numberOfLines = 1
    
    self.titleLabel.attributedText = titleText.applyTextAttributes(
      attributes:
        [
          NSAttributedString.Key.font: UIFont.pretendardBodyBold,
          NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
        ]
    )
    
    self.descriptionLabel.attributedText = descriptionText.applyTextAttributes(
      attributes:
        [
          NSAttributedString.Key.font: UIFont.pretendardDetailRegular12,
          NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
        ]
    )
    
    self.addSubview(titleLabel)
    self.addSubview(descriptionLabel)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.leafImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.leafImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.leafImageView.widthAnchor.constraint(equalToConstant: Constant.LeafLabel.logoLength),
      self.leafImageView.heightAnchor.constraint(equalToConstant: Constant.LeafLabel.logoLength),

      self.titleLabel.leadingAnchor.constraint(
        equalTo: self.leafImageView.trailingAnchor,
        constant: Constant.LeafLabel.labelLeading
      ),
      self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
      
      self.descriptionLabel.leadingAnchor.constraint(
        equalTo: self.leafImageView.trailingAnchor,
        constant: Constant.LeafLabel.labelLeading
      ),
      self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}

}
