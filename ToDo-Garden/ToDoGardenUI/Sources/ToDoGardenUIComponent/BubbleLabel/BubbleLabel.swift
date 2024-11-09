//
//  BubbleLabel.swift
//
//
//  Created by SONG on 11/8/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public protocol BubbleLabelDelegate: AnyObject {
  func didTap()
}

public final class BubbleLabel: UIView {
  private let bubbleTextBox: BubbleTextBox
  private let tailView: TailView
  private let tailPosition: BubbleLabel.TailPosition
  public weak var delegate: BubbleLabelDelegate?
  
  public enum TailPosition {
    case left
    case right
  }
  
  public init(
    tailPosition: BubbleLabel.TailPosition,
    iconImage: UIImage,
    text: String
  ) {
    self.tailPosition = tailPosition
    self.bubbleTextBox = BubbleTextBox(iconImage: iconImage, text: text)
    self.tailView = TailView()
    super.init(frame: CGRect.zero)
    self.setupView()
    self.backgroundColor = UIColor.clear
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    self.backgroundColor = UIColor.white
    self.addSubviews()
    self.setupTapAction()
    self.setupConstraints()
  }
  
  private func addSubviews() {
    self.addSubview(self.bubbleTextBox)
    self.addSubview(self.tailView)
  }
  
  private func setupTapAction() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
    self.bubbleTextBox.addGestureRecognizer(tapGesture)
    self.bubbleTextBox.cancelButton.addTarget(
      self,
      action: #selector(self.handleTap),
      for: UIControl.Event.touchUpInside
    )
  }
  
  @objc private func handleTap() {
    self.delegate?.didTap()
  }
  
  private func setupConstraints() {
    self.bubbleTextBox.usingAutolayout()
    self.tailView.usingAutolayout()
    
    self.setupBubbleTextBoxConstraints()
    self.setupTailViewInitialConstraints()
    self.setupTailViewConstraints()
  }
  
  private func setupBubbleTextBoxConstraints() {
    let margin = Constant.BubbleLabel.commonMargin
    
    NSLayoutConstraint.activate([
      self.bubbleTextBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
      self.bubbleTextBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
      self.bubbleTextBox.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
      self.bubbleTextBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin)
    ])
    
    self.sizeToFit()
  }
  
  private func setupTailViewInitialConstraints() {
    let margin = Constant.BubbleLabel.commonMargin
    
    NSLayoutConstraint.activate([
      self.tailView.widthAnchor.constraint(equalToConstant: 2 * margin),
      self.tailView.heightAnchor.constraint(equalToConstant: margin),
      self.tailView.bottomAnchor.constraint(equalTo: self.bubbleTextBox.topAnchor)
    ])
  }
  
  private func setupTailViewConstraints() {
    let margin = Constant.BubbleLabel.tailPositionMargin
    switch self.tailPosition {
    case .left:
      self.tailView.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
    case .right:
      self.tailView.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = BubbleLabel(
    tailPosition: .right,
    iconImage: UIImage.createToDoButtonImage,
    text: "버튼을 눌러 제발 눌러서 그룹을\n추가해보지 않을래?응? Lorem 어쩌구저쩌구 ㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇ"
  )
  return view
}
