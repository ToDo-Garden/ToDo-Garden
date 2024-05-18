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
  var repetitionLabel: UILabel
  var selectionImageView: UIImageView

  public init(model: Model) {
    self.model = model
    self.repetitionLabel = UILabel()
    self.selectionImageView = UIImageView()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension ToDoRepeatSelectionView {
  private func setup() {
    self.setupLayer()
    self.setupRepetitionLabel()
    self.setupSelectionImageView()
  }

  private func setupLayer() {
    self.layer.borderWidth = self.model.borderWidth
    self.layer.cornerRadius = self.model.cornerRadius
  }

  private func setupRepetitionLabel() {
    self.repetitionLabel.font = UIFont.pretendardBodyMedium
    self.repetitionLabel.text = self.model.title
  }

  private func setupSelectionImageView() {
    guard self.model.selectedStateImage != nil
    else { return }

    let image = self.model.selectedStateImage
    self.selectionImageView.image = image
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
