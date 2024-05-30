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
  var tapGestureRecognizer: UITapGestureRecognizer
  var repetitionLabelTopAchor: NSLayoutConstraint
  var isSelected: Bool {
    willSet {
      newValue ? self.setSelected() : self.setDeSelected()
    }
  }

  public init(model: Model) {
    self.model = model
    self.repetitionLabel = UILabel()
    self.selectionImageView = UIImageView()
    self.tapGestureRecognizer = UITapGestureRecognizer()
    self.repetitionLabelTopAchor = NSLayoutConstraint()
    self.isSelected = false
    super.init(frame: CGRect.zero)
    self.setup()
    self.setDeSelected()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public var intrinsicContentSize: CGSize {
    return Constant.ToDoRepeatSelectionView.Layout.size
  }

  public func setSelected() {
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.layer.borderColor = UIColor.toDoGardenGreenDark.cgColor
    self.repetitionLabel.textColor = UIColor.toDoGardenGreenDark
    self.selectionImageView.isHidden = false
  }

  public func setDeSelected() {
    self.backgroundColor = UIColor.clear
    self.layer.borderColor = UIColor.toDoGardenGray2.cgColor
    self.repetitionLabel.textColor = UIColor.toDoGardenGray3
    self.selectionImageView.isHidden = true
  }
}

// MARK: Private Functions

extension ToDoRepeatSelectionView {
  private func setup() {
    self.setupLayer()
    self.setupRepetitionLabel()
    self.setupSelectionImageView()
    self.setupTapGestureRecognizer()
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

  private func setupTapGestureRecognizer() {
    self.addGestureRecognizer(self.tapGestureRecognizer)
    self.tapGestureRecognizer.addTarget(self, action: #selector(self.didTapView))
  }
}

// MARK: Tap Gesture Function

extension ToDoRepeatSelectionView {
  @objc func didTapView() {
    self.isSelected = !self.isSelected
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

// MARK: Preview

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = ToDoRepeatSelectionView(model: ToDoRepeatSelectionView.Model.anotherDay)

  return view
}
#endif
