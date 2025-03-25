//
//  EnterGuideSceneButton.swift
//  ToDoGardenUI
//
//  Created by SONG on 3/25/25.
//

import UIKit

import ToDoGardenUIResource

// swiftlint: disable all
public final class EnterGuideSceneButton: UIButton {
  public init(title: String) {
    super.init(frame: .zero)
    self.setupUI(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI(title: String) {
    let attributedTitle = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold15,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    let titleLabel = UILabel()
    titleLabel.attributedText = attributedTitle
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.layer.cornerRadius = 10.0
    self.layer.borderWidth = 2.0
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    
    let chevronImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
    let chevronImageView = UIImageView(image: chevronImage)
    chevronImageView.tintColor = UIColor.toDoGardenGreenDark
    chevronImageView.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(titleLabel)
    self.addSubview(chevronImageView)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 38),
      titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      chevronImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      chevronImageView.widthAnchor.constraint(equalToConstant: 6),
      chevronImageView.heightAnchor.constraint(equalToConstant: 12)
    ])
  }
}
// swiftlint: enable all
