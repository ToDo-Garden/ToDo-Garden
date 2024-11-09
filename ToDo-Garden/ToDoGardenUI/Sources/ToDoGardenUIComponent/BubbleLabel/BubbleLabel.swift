//
//  BubbleLabel.swift
//
//
//  Created by SONG on 11/8/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource
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
}
