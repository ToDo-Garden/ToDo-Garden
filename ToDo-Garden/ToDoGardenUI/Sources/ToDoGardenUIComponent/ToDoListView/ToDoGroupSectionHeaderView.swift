//
//  ToDoGroupSectionHeaderView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/10/24.
//
import UIKit

import ToDoGardenUIResource

final class ToDoGroupSectionHeaderView: UICollectionReusableView {
  private let contentView: UIView = {
    let contentView = UIView()
    contentView.backgroundColor = UIColor.white
    
    return contentView
  }()
  
  private let progressView: CircularProgressView = {
    let progressView = CircularProgressView(
      progressColor: UIColor.toDoGardenGray1,
      backgroundColor: UIColor.toDoGardenGray1,
      lineWidth: 4.0
    )
    progressView.usingAutolayout()
    NSLayoutConstraint.activate([
      progressView.widthAnchor.constraint(equalToConstant: 24),
      progressView.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    return progressView
  }()
  
  private let createToDoButton: CreateToDoButton = CreateToDoButton(
    model: CreateToDoButton.Model.primary
  )
  
  private let timerImageView: UIImageView = {
    let timerImageView = UIImageView(image: UIImage.timerButtonImage)
    timerImageView.usingAutolayout()
    NSLayoutConstraint.activate([
      timerImageView.widthAnchor.constraint(equalToConstant: 24),
      timerImageView.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    return timerImageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  struct UIModel {
    let progressColor: UIColor
    let progressRate: Double
    let groupTitle: String
  }
  
  func update(with model: UIModel) {
    self.progressView.setupProgressLayerStrokeColor(with: model.progressColor)
    self.progressView.startAnimation(
      duration: TimeInterval(0.5),
      from: Float.zero,
      to: Float(model.progressRate)
    )
    self.createToDoButton.updateTitle(with: model.groupTitle)
  }
}

extension ToDoGroupSectionHeaderView {
  private func setup() {
    self.setupLayout()
  }
  
  private func setupLayout() {
    self.addSubview(self.contentView)
    self.contentView.equalToParent()
    let spacer = UIView()
    spacer.setContentHuggingPriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.horizontal
    )
    let hStack = UIHStackView(
      arrangedSubviews: [
        self.progressView,
        self.createToDoButton,
        spacer,
        self.timerImageView
      ]
    )
    self.contentView.addSubview(hStack)
    hStack.setCustomSpacing(4.0, after: self.progressView)
    hStack.equalToParent()
    
    hStack.layoutMargins = UIEdgeInsets(top: .zero, left: 31, bottom: .zero, right: 40)
    hStack.isLayoutMarginsRelativeArrangement = true
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = ToDoGroupSectionHeaderView()
  view.usingAutolayout()
  
  DispatchQueue.main.asyncAfter(
    deadline: .now() + 0.5,
    execute: {
      view.update(
        with: ToDoGroupSectionHeaderView.UIModel(
          progressColor: UIColor.toDoGardenRed,
          progressRate: 0.7,
          groupTitle: "불어 독해"
        )
      )
  })
  return view
}
