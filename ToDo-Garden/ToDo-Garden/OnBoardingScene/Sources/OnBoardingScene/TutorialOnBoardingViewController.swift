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
  
  var endEvent: (() -> Void)?
  
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
    self.setupCell()
    self.setupBubbleLabels()
  }
}

extension TutorialOnBoardingViewController {
  private func setupCell() {
    self.cell.isUserInteractionEnabled = false
    self.cell.applyModelSecondary(
      id: UUID(),
      groupName: Constant.StringLiteral.groupName,
      progressColor: UIColor.red,
      progressRate: 0.5
    )
    self.cell.usingAutolayout()
    self.view.addSubview(self.cell)
    
    NSLayoutConstraint.activate(
      [
        self.cell.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.cell.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        self.cell.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.cell.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
      ]
    )
  }
  
  private func setupBubbleLabels() {
    self.leftBubbleLabel.delegate = self
    self.rightBubbleLabel.delegate = self
    
    self.view.addSubview(self.leftBubbleLabel)
    self.view.addSubview(self.rightBubbleLabel)
    
    self.leftBubbleLabel.usingAutolayout()
    self.rightBubbleLabel.usingAutolayout()
    
    self.setBubbleConstraints()
    
    self.leftBubbleLabel.alpha = 1
    self.rightBubbleLabel.alpha = 0
  }
  
  private func setBubbleConstraints() {
    guard let groupNameButton = self.cell.groupNameButton,
      let rightImageButton = self.cell.rightImageButton else {
      return
    }
    
    let constant = Constant.Layout.self
    NSLayoutConstraint.activate([
      self.leftBubbleLabel.topAnchor.constraint(
        equalTo: groupNameButton.bottomAnchor,
        constant: constant.bubbleLabelMargin
      ),
      self.leftBubbleLabel.leadingAnchor.constraint(
        equalTo: groupNameButton.trailingAnchor,
        constant: constant.leftBubbleLabelLeading
      ),
      self.rightBubbleLabel.topAnchor.constraint(
        equalTo: rightImageButton.bottomAnchor,
        constant: constant.bubbleLabelMargin
      ),
      self.rightBubbleLabel.trailingAnchor.constraint(
        equalTo: rightImageButton.centerXAnchor,
        constant: constant.rightBubbleLabelTrailing
      )
    ])
    self.leftBubbleLabel.isHidden = false
  }
}

extension TutorialOnBoardingViewController: BubbleLabelDelegate {
  public func didTap() {
    if !self.leftBubbleLabel.isHidden {
      self.animateLeftBubbleLabel()
    } else if !self.rightBubbleLabel.isHidden {
      self.animateRightBubbleLabel()
    }
  }
  
  private func animateLeftBubbleLabel() {
    UIView.animate(
      withDuration: 0.5,
      animations: { [weak self] in
        self?.leftBubbleLabel.alpha = 0
      },
      completion: { [weak self] _ in
        self?.leftBubbleLabel.isHidden = true
        self?.rightBubbleLabel.isHidden = false
        self?.showRightBubbleLabel()
      }
    )
  }
  
  private func showRightBubbleLabel() {
    UIView.animate(
      withDuration: 0.5,
      animations: { [weak self] in
        self?.rightBubbleLabel.alpha = 1
      }
    )
  }
  
  private func animateRightBubbleLabel() {
    UIView.animate(
      withDuration: 0.5,
      animations: { [weak self] in
        self?.rightBubbleLabel.alpha = 0
      },
      completion: { [weak self] _ in
        self?.rightBubbleLabel.isHidden = true
        self?.endEvent?()
      }
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = TutorialOnBoardingViewController()
  let navi = UINavigationController(rootViewController: viewController)
  return navi
}
#endif
