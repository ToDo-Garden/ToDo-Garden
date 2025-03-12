//
//  TutorialOnBoardingViewController.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import HomeScene
import RootTabBar
import ToDoGardenUIComponent
import ToDoGardenUIResource

public final class TutorialOnBoardingViewController: HomeSceneViewController {
  private let cell1: ManageGroupTableViewCell
  private let cell2: ManageGroupTableViewCell
  private let leftBubbleLabel: BubbleLabel
  private let rightBubbleLabel: BubbleLabel
  private let bottomSheet: BottomSheet
  private let tabBar: RootTabBarController.RootTabBar
  
  public var endAction: (() -> Void)?
  
  public override init() {
    self.cell1 = ManageGroupTableViewCell(
      style: UITableViewCell.CellStyle.default,
      reuseIdentifier: ManageGroupTableViewCell.identifier
    )
    self.cell2 = ManageGroupTableViewCell(
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
    self.bottomSheet = BottomSheet()
    self.tabBar = RootTabBarController.RootTabBar()
    super.init()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupCell()
    self.setupBubbleLabels()
    self.setupGestureRecognizers()
    self.setUserInteractionDisable()
    self.setupTabBar()
  }
  
  override public func setBottomSheet() {
    self.bottomSheet.usingAutolayout()
    self.view.addSubview(self.bottomSheet)
    self.bottomSheet.isUserInteractionEnabled = false
  }
}

extension TutorialOnBoardingViewController {
  private func setupTabBar() {
    self.tabBar.items = self.makeTabBarItems()
    self.tabBar.barTintColor = .white
    self.tabBar.tintColor = .toDoGardenGreenDark
    self.tabBar.selectedItem = self.tabBar.items?[0]
    self.tabBar.isUserInteractionEnabled = false
    self.view.addSubview(self.tabBar)
    self.tabBar.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.tabBar.heightAnchor.constraint(equalToConstant: Constant.Layout.tabBarHeight)
    ])
  }

  private func makeTabBarItems() -> [UITabBarItem] {
    return [
      (Constant.StringLiteral.tabBarHome, UIImage.homeTabBarItemImage, 0),
      (Constant.StringLiteral.tabBarShare, UIImage.shareTabBarItemImage, 1),
      (Constant.StringLiteral.tabBarSettings, UIImage.settingsTabBarItemImage, 2)
    ].map { UITabBarItem(title: $0.0, image: $0.1, tag: $0.2) }
  }

  // swiftlint:disable function_body_length
  private func setupCell() {
    self.cell1.isUserInteractionEnabled = false
    self.cell1.applyModelSecondary(
      id: UUID(),
      groupName: Constant.StringLiteral.groupName1,
      progressColor: UIColor.toDoGardenYellow,
      progressRate: 0.5
    )
    self.cell1.usingAutolayout()
    self.view.addSubview(self.cell1)
    
    self.cell2.isUserInteractionEnabled = false
    self.cell2.applyModelSecondary(
      id: UUID(),
      groupName: Constant.StringLiteral.groupName2,
      progressColor: UIColor.red,
      progressRate: 1.0
    )
    self.cell2.usingAutolayout()
    self.view.addSubview(self.cell2)
    
    NSLayoutConstraint.activate([
      self.cell1.heightAnchor.constraint(equalToConstant: Constant.Layout.cellHeight),
      self.cell1.centerXAnchor.constraint(equalTo: self.bottomSheet.centerXAnchor),
      self.cell1.leadingAnchor.constraint(
        equalTo: self.bottomSheet.leadingAnchor,
        constant: Constant.Layout.cellLeading
      ),
      self.cell1.trailingAnchor.constraint(equalTo: self.bottomSheet.trailingAnchor),
      self.cell1.topAnchor.constraint(
        equalTo: self.bottomSheet.topAnchor,
        constant: Constant.Layout.cellTopMargin1
      ),

      self.cell2.heightAnchor.constraint(equalToConstant: Constant.Layout.cellHeight),
      self.cell2.centerXAnchor.constraint(equalTo: self.bottomSheet.centerXAnchor),
      self.cell2.leadingAnchor.constraint(
        equalTo: self.bottomSheet.leadingAnchor,
        constant: Constant.Layout.cellLeading
      ),
      self.cell2.trailingAnchor.constraint(equalTo: self.bottomSheet.trailingAnchor),
      self.cell2.topAnchor.constraint(
        equalTo: self.cell1.bottomAnchor,
        constant: Constant.Layout.cellTopMargin2
      )
    ])
  }
  // swiftlint:enable function_body_length
  
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
    guard let groupNameButton = self.cell2.groupNameButton,
      let rightImageButton = self.cell2.rightImageButton else {
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
        self?.endAction?()
      },
      completion: { [weak self] _ in
        self?.rightBubbleLabel.isHidden = true
      }
    )
  }
  
  private func animateRightBubbleLabelAndEndAction() {
    UIView.animate(
      withDuration: 0.5,
      animations: { [weak self] in
        self?.rightBubbleLabel.alpha = 0
      },
      completion: { [weak self] _ in
        self?.rightBubbleLabel.isHidden = true
        self?.endAction?()
      }
    )
  }
  
  private func animateRightBubbleLabelToLeft() {
    UIView.animate(
      withDuration: 0.5,
      animations: { [weak self] in
        self?.rightBubbleLabel.alpha = 0
      },
      completion: { [weak self] _ in
        self?.rightBubbleLabel.isHidden = true
        self?.leftBubbleLabel.isHidden = false
        self?.showLeftBubbleLabel()
      }
    )
  }
  
  private func showLeftBubbleLabel() {
    UIView.animate(
      withDuration: 0.5,
      animations: { [weak self] in
        self?.leftBubbleLabel.alpha = 1
      }
    )
  }
}

extension TutorialOnBoardingViewController {
  private func setupGestureRecognizers() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    self.view.addGestureRecognizer(panGesture)
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard gesture.state == UIGestureRecognizer.State.ended else { return }
    
    let velocity = gesture.velocity(in: self.view)
    let isHorizontal = abs(velocity.x) > abs(velocity.y)
    
    if isHorizontal {
      if velocity.x > 0 {
        if !self.rightBubbleLabel.isHidden {
          self.animateRightBubbleLabelToLeft()
        }
      } else {
        if !self.leftBubbleLabel.isHidden {
          self.animateLeftBubbleLabel()
        } else if !self.rightBubbleLabel.isHidden {
          self.animateRightBubbleLabelAndEndAction()
        }
      }
    }
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
