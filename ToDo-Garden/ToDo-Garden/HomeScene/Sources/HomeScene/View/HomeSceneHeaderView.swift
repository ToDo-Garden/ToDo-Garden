//
//  HomeSceneHeaderView.swift
//  HomeScene
//
//  Created by Noah on 1/23/25.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

final class HomeSceneHeaderView: UIView {
  private let manageGroupButton: UIButton = {
    let manageGroupButton = UIButton()
    manageGroupButton.setImage(
      UIImage.homeManageGroupImage,
      for: UIControl.State.normal
    )
    
    return manageGroupButton
  }()
  
  private lazy var contentView: UIStackView = {
    let spacer = UIView()
    let homeSymbolImageView = UIImageView(
      image: UIImage.homeHeaderSymbolImage
    )
    let contentView = UIHStackView(
      arrangedSubviews: [
        homeSymbolImageView,
        spacer,
        self.manageGroupButton
      ]
    )
    contentView.isLayoutMarginsRelativeArrangement = true
      
    return contentView
  }()
  
  var contentViewLayoutMargins: UIEdgeInsets? {
    didSet {
      if let contentViewLayoutMargins = self.contentViewLayoutMargins {
        self.contentView.layoutMargins = contentViewLayoutMargins
      }
    }
  }
  
  var manageGroupButtonTapped: UIAction? {
    didSet {
      if let manageGroupButtonTapped = self.manageGroupButtonTapped {
        self.manageGroupButton.addAction(
          manageGroupButtonTapped,
          for: UIControl.Event.touchUpInside
        )
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeSceneHeaderView {
  private func setup() {
    self.setupLayout()
  }
  
  private func setupLayout() {
    self.addSubview(self.contentView)
    self.contentView.equalToParent()
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let headerView = HomeSceneHeaderView()
  headerView.contentViewLayoutMargins = UIEdgeInsets(
    top: 0,
    left: 21,
    bottom: 0,
    right: 30
  )
  headerView.manageGroupButtonTapped = UIAction { _ in
    print("Hello")
  }
  return headerView
}
#endif
