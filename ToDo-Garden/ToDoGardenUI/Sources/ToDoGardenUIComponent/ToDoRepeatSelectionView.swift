//
//  ToDoRepeatSelectionView.swift
//
//
//  Created by Wood on 5/19/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public class ToDoRepeatSelectionView: UIView {
  let model: Model

  public init(model: Model) {
    self.model = model
    super.init(frame: CGRect.zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Model

extension ToDoRepeatSelectionView {
  public struct Model {
    let title: String
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    var selectedStateImage: UIImage?

    public init(
      title: String,
      borderWidth: CGFloat,
      cornerRadius: CGFloat,
      selectedStateImage: UIImage? = nil
    ) {
      self.title = title
      self.borderWidth = borderWidth
      self.cornerRadius = cornerRadius
      self.selectedStateImage = selectedStateImage
    }

    public static let onlyToday = Self(
      title: Constant.ToDoRepeatSelectionView.StringLiteral.RepetitionLabel.onlyToday,
      borderWidth: Constant.ToDoRepeatSelectionView.Layout.borderWidth,
      cornerRadius: Constant.ToDoRepeatSelectionView.Layout.cornerRadius,
      selectedStateImage: UIImage.checkmarkImage
    )

    public static let anotherDay = Self(
      title: Constant.ToDoRepeatSelectionView.StringLiteral.RepetitionLabel.anotherDay,
      borderWidth: Constant.ToDoRepeatSelectionView.Layout.borderWidth,
      cornerRadius: Constant.ToDoRepeatSelectionView.Layout.cornerRadius
    )
  }
}
