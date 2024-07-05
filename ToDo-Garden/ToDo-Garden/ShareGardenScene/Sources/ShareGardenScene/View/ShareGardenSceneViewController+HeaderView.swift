//
//  ShareGardenSceneViewController+HeaderView.swift
//
//
//  Created by Noah on 7/5/24.
//

import UIKit

import TDUtility

import ToDoGardenUIComponent
import ToDoGardenUIResource

extension ShareGardenSceneViewController {
  final class HeaderView: UIStackView {
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
      let titleLabel = UILabel()
      titleLabel.text = Constant.StringLiteral.HeaderView.title
      titleLabel.numberOfLines = 1
      titleLabel.font = UIFont.pretendardHeadBold
      titleLabel.textColor = UIColor.toDoGardenGreenDark
      
      return titleLabel
    }()
    
    private let shareButton: UIButton = {
      let shareButton = UIButton()
      shareButton.setImage(
        UIImage.shareIconImage,
        for: UIControl.State.normal
      )
      
      return shareButton
    }()
    
    // MARK: - Properties
    
    @ExecuteOnce private var configureSpacingOnce: (() -> Void)?
    
    // MARK: - Object life cycle
    
    init() {
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.configureSpacingOnce = {
        self.setupSpacing()
      }
    }
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController.HeaderView {
  private func setup() {
    self.setupAppearance()
    self.setupLayoutPriorities()
    self.addSubviews()
  }
  
  private func setupAppearance() {
    self.axis = NSLayoutConstraint.Axis.horizontal
    self.distribution = UIStackView.Distribution.fill
    self.alignment = UIStackView.Alignment.center
  }
  
  private func setupLayoutPriorities() {
    self.titleLabel.setContentCompressionResistancePriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.horizontal
    )
    self.titleLabel.setContentHuggingPriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.horizontal
    )
    
    self.shareButton.setContentHuggingPriority(
      UILayoutPriority.required,
      for: NSLayoutConstraint.Axis.horizontal
    )
    self.shareButton.setContentCompressionResistancePriority(
      UILayoutPriority.required,
      for: NSLayoutConstraint.Axis.horizontal
    )
  }
  
  private func addSubviews() {
    self.addArrangedSubview(self.titleLabel)
    self.addArrangedSubview(self.shareButton)
  }
  
  private func setupSpacing() {
    self.spacing = self.bounds.width * (194 / 323)
  }
}
