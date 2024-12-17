//
//  ToDoGroupSectionHeaderView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/10/24.
//
import UIKit

import ToDoGardenUIResource

final class ToDoGroupSectionHeaderView: UICollectionReusableView {
  private let contentView: UIView = {
    let contentView = UIView()
    contentView.backgroundColor = UIColor.white
    
    return contentView
  }()
  
  private let progressView: CircularProgressView = {
    let progressView = CircularProgressView(
      progressColor: UIColor.toDoGardenGray1,
      backgroundColor: UIColor.toDoGardenGray1,
      lineWidth: 4.0
    )
    progressView.usingAutolayout()
    NSLayoutConstraint.activate([
      progressView.widthAnchor.constraint(equalToConstant: 24),
      progressView.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    return progressView
  }()
  
  private let createToDoButton: CreateToDoButton = CreateToDoButton(
    model: CreateToDoButton.Model.primary
  )
  
  private let timerImageView: UIImageView = {
    let timerImageView = UIImageView(image: UIImage.timerButtonImage)
    timerImageView.usingAutolayout()
    NSLayoutConstraint.activate([
      timerImageView.widthAnchor.constraint(equalToConstant: 24),
      timerImageView.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    return timerImageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ToDoGroupSectionHeaderView {
  private func setup() {
    self.setupLayout()
  }
  
  private func setupLayout() {
    self.addSubview(self.contentView)
    self.contentView.equalToParent()
    let spacer = UIView()
    spacer.setContentHuggingPriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.horizontal
    )
    let hStack = UIHStackView(
      arrangedSubviews: [
        self.progressView,
        self.createToDoButton,
        spacer,
        self.timerImageView
      ]
    )
    self.contentView.addSubview(hStack)
    hStack.setCustomSpacing(4.0, after: self.progressView)
    hStack.equalToParent()
    
    hStack.layoutMargins = UIEdgeInsets(top: .zero, left: 31, bottom: .zero, right: 40)
    hStack.isLayoutMarginsRelativeArrangement = true
  }
}
