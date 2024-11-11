//
//  TutorialOnBoardingViewController.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

final class TutorialOnBoardingViewController: UIViewController {
  private let cell: ManageGroupTableViewCell
  private let leftBubbleLabel: BubbleLabel
  private let rightBubbleLabel: BubbleLabel
  
  init() {
    self.cell = ManageGroupTableViewCell(
      style: UITableViewCell.CellStyle.default,
      reuseIdentifier: ManageGroupTableViewCell.identifier
    )
    self.leftBubbleLabel = BubbleLabel(
      tailPosition: BubbleLabel.TailPosition.left,
      iconImage: UIImage.addButton,
      text: Constant.StringLiteral.leftBubbleTitle
    )
    self.rightBubbleLabel = BubbleLabel(
      tailPosition: BubbleLabel.TailPosition.right,
      iconImage: UIImage.timerButtonImage,
      text: Constant.StringLiteral.rightBubbleTitle
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
  }
}
