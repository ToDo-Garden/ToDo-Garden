//
//  GroupNameLabel.swift
//
//
//  Created by Wood on 4/26/24.
//

import UIKit

import ToDoGardenUIResource

public final class GroupNameLabel: UILabel {
  private var configuration: GroupNameLabel.Configuration
  
  public override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize

    contentSize.width += (
      self.configuration.primaryModel.textPadding.left +
      self.configuration.primaryModel.textPadding.right
    )
    contentSize.height += (
      self.configuration.primaryModel.textPadding.top +
      self.configuration.primaryModel.textPadding.bottom
    )

    return contentSize
  }
  
  public init(configuration: GroupNameLabel.Configuration) {
    self.configuration = configuration
    super.init(frame: CGRect.zero)
    self.setupUI()
  }
  
  public required init?(coder: NSCoder) {
    self.configuration = GroupNameLabel.Configuration.primary(Configuration.PrimaryModel.defaultPrimaryModel)
    super.init(coder: coder)
    self.setupUI()
  }
  
  public override func drawText(in rect: CGRect) {
    let textPadding = self.configuration.primaryModel.textPadding

    super.drawText(
      in: rect.inset(
        by: textPadding
      )
    )
  }

  public func updateText(with text: String) {
    self.text = text
  }
}

// MARK: Private Functions

extension GroupNameLabel {
  private func setupUI() {
    self.setupBackgroundColor()
    self.setupText()
    self.setupRoundedCorner()
  }
  
  private func setupBackgroundColor() {
    self.backgroundColor = self.configuration.primaryModel.backgroundColor
  }
  
  private func setupText() {
    self.font = self.configuration.primaryModel.font
    self.textColor = self.configuration.primaryModel.textColor
  }
  
  private func setupRoundedCorner() {
    self.clipsToBounds = true
    self.layer.cornerRadius = self.configuration.primaryModel.cornerRadius
  }
}

// MARK: Configuration

extension GroupNameLabel {
  public enum Configuration {
    var primaryModel: GroupNameLabel.Configuration.PrimaryModel {
      if case let GroupNameLabel.Configuration.primary(model) = self {
        return model
      }
      return .defaultPrimaryModel
    }

    case primary(GroupNameLabel.Configuration.PrimaryModel)
  }
}

extension GroupNameLabel.Configuration {
  public static let primaryConfigration = GroupNameLabel.Configuration.primary(
    PrimaryModel.defaultPrimaryModel
  )
}

// MARK: Models

extension GroupNameLabel.Configuration {
  public struct PrimaryModel {
    let cornerRadius: CGFloat
    let textPadding: UIEdgeInsets
    let font: UIFont
    let textColor: UIColor
    let backgroundColor: UIColor
    
    static let defaultPrimaryModel = GroupNameLabel.Configuration.PrimaryModel(
      cornerRadius: Constant.GroupNameLabel.Layout.cornerRadius,
      textPadding: UIEdgeInsets(
        top: Constant.GroupNameLabel.Layout.TextPadding.top,
        left: Constant.GroupNameLabel.Layout.TextPadding.left,
        bottom: Constant.GroupNameLabel.Layout.TextPadding.bottom,
        right: Constant.GroupNameLabel.Layout.TextPadding.right
      ),
      font: UIFont.pretendardBodyBold,
      textColor: UIColor.toDoGardenGreenDark,
      backgroundColor: UIColor.toDoGardenGreenBackground
    )
  }
}
