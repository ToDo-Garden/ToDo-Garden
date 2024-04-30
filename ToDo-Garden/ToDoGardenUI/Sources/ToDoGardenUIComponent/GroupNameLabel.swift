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
    
    switch self.configuration {
    case let .primary(model):
      contentSize.width += (model.textPadding.left + model.textPadding.right)
      contentSize.height += (model.textPadding.top + model.textPadding.bottom)
    }
    
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
    let textPadding: UIEdgeInsets
    switch self.configuration {
    case let .primary(model):
      textPadding = model.textPadding
    }
    
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

// MARK: private functions

extension GroupNameLabel {
  private func setupUI() {
    self.setupBackgroundColor()
    self.setupText()
    self.setupRoundedCorner()
  }
  
  private func setupBackgroundColor() {
    switch self.configuration {
    case let .primary(model):
      self.backgroundColor = model.backgroundColor
    }
  }

  private func setupText() {
    switch self.configuration {
    case let .primary(model):
      self.font = model.font
      self.textColor = model.textColor
    }
  }
  
  private func setupRoundedCorner() {
    switch self.configuration {
    case let .primary(model):
      self.clipsToBounds = true
      self.layer.cornerRadius = model.cornerRadius
    }
  }
}

// MARK: configuration

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

// MARK: models

extension GroupNameLabel.Configuration {
  public struct PrimaryModel {
    let cornerRadius: CGFloat
    let textPadding: UIEdgeInsets
    let font: UIFont
    let textColor: UIColor
    let backgroundColor: UIColor
    
    static let defaultPrimaryModel = GroupNameLabel.Configuration.PrimaryModel(
      cornerRadius: 12,
      textPadding: UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12),
      font: UIFont.pretendardBodyBold,
      textColor: UIColor.toDoGardenGreenDark,
      backgroundColor: UIColor.toDoGardenGreenBackground
    )
  }
}
