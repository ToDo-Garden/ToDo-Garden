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

  var repetitionLabelTopAchor: NSLayoutConstraint

  public init(model: Model) {
    self.model = model
    self.repetitionLabel = UILabel()
    self.selectionImageView = UIImageView()
    self.repetitionLabelTopAchor = NSLayoutConstraint()
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
    self.addSubviews()
    self.setupSubviewsLayout()
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

// MARK: Set Auto Layout

extension ToDoRepeatSelectionView {
  private func addSubviews() {
    self.addSubview(self.repetitionLabel)
    self.addSubview(self.selectionImageView)
  }

  private func setupSubviewsLayout() {
    self.setupLabelLayout()
    self.setupSelectionImageViewLayout()
  }

  private func setupLabelLayout() {
    self.repetitionLabel.usingAutolayout()

    self.repetitionLabelTopAchor = self.repetitionLabel.topAnchor.constraint(
      equalTo: self.topAnchor,
      constant: Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel.topMargin
    )
    self.repetitionLabelTopAchor.isActive = true

    self.repetitionLabel.leadingAnchor.constraint(
      equalTo: self.leadingAnchor,
      constant: Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel.leadingMargin
    ).isActive = true
  }

  private func setupSelectionImageViewLayout() {
    self.selectionImageView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.selectionImageView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.ToDoRepeatSelectionView.Layout.SelectionImageView.trailingMargin
        ),
        self.selectionImageView.centerYAnchor.constraint(equalTo: self.repetitionLabel.centerYAnchor)
      ]
    )
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
