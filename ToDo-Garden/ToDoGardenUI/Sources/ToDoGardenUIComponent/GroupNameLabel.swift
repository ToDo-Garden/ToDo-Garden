//
//  GroupNameLabel.swift
//
//
//  Created by Wood on 4/26/24.
//

import UIKit

import ToDoGardenUIResource

extension Styled {
  open class UILabel: UIKit.UILabel {
    private var configuration: Styled.UILabel.Configuration

    public override var intrinsicContentSize: CGSize {
      var contentSize = super.intrinsicContentSize

      switch self.configuration {
      case let .groupName(groupNameModel):
        contentSize.width += (groupNameModel.textPadding.left + groupNameModel.textPadding.right)
        contentSize.height += (groupNameModel.textPadding.top + groupNameModel.textPadding.bottom)
      }

      return contentSize
    }

    init(configuration: Styled.UILabel.Configuration) {
      self.configuration = configuration
      super.init(frame: CGRect.zero)
      self.setupUI()
    }

    public required init?(coder: NSCoder) {
      self.configuration = Styled.UILabel.Configuration.groupName(Configuration.GroupNameModel.defaultPrimaryModel)
      super.init(coder: coder)
      self.setupUI()
    }

    public override func drawText(in rect: CGRect) {
      let textPadding: UIEdgeInsets
      switch self.configuration {
      case let .groupName(groupNameModel):
        textPadding = groupNameModel.textPadding
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
}

// MARK: configuration

extension Styled.UILabel {
  enum Configuration {
    var groupNameModel: Styled.UILabel.Configuration.GroupNameModel {
      if case let Styled.UILabel.Configuration.groupName(model) = self {
        return model
      }
      return Styled.UILabel.Configuration.GroupNameModel.defaultPrimaryModel
    }

    case groupName(Styled.UILabel.Configuration.GroupNameModel)
  }
}

extension Styled.UILabel.Configuration {
  struct GroupNameModel {
    
  }
}
