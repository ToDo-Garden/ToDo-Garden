//
//  ToDoGroupSectionHeaderView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/10/24.
//
import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class ToDoGroupSectionHeaderView: UICollectionReusableView {
  typealias LayoutConstant = Constant.ToDoGroupSectionHeaderView.Layout
  
  private let contentView: UIView = {
    let contentView = UIView()
    contentView.backgroundColor = UIColor.white
    
    return contentView
  }()
  
  private let progressView: CircularProgressView = {
    let progressView = CircularProgressView(
      progressColor: UIColor.toDoGardenGray1,
      backgroundColor: UIColor.toDoGardenGray1,
      lineWidth: LayoutConstant.progressViewLineWidth
    )
    progressView.usingAutolayout()
    
    let progressViewSize = LayoutConstant.progressViewSize
    NSLayoutConstraint.activate([
      progressView.widthAnchor.constraint(equalToConstant: progressViewSize.width),
      progressView.heightAnchor.constraint(equalToConstant: progressViewSize.height)
    ])
    
    return progressView
  }()
  
  private let createToDoButton: CreateToDoButton = CreateToDoButton(
    model: CreateToDoButton.Model.primary
  )
  
  private let timerButton: UIButton = {
    let timerButton = UIButton()
    timerButton.setImage(UIImage.timerButtonImage, for: UIControl.State.normal)
    timerButton.usingAutolayout()
    
    let timerImageViewSize = LayoutConstant.timerImageViewSize
    NSLayoutConstraint.activate([
      timerButton.widthAnchor.constraint(equalToConstant: timerImageViewSize.width),
      timerButton.heightAnchor.constraint(equalToConstant: timerImageViewSize.height)
    ])
    
    return timerButton
  }()
  
  weak var delegate: ToDoGroupSectionHeaderViewDelegate?
  var section: Int = Int.zero
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func update(with model: ToDoListView.ToDoGroupUIModel) {
    self.progressView.setupProgressLayerStrokeColor(with: model.progressColor)
    self.progressView.startAnimation(
      duration: TimeInterval(0.5),
      from: self.progressView.currentProgress,
      to: Float(model.progressRate)
    )
    self.createToDoButton.updateTitle(with: model.groupTitle)
  }
}

extension ToDoGroupSectionHeaderView {
  private func setup() {
    self.setupLayout()
    self.setupButtonAction()
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
        self.timerButton
      ]
    )
    self.contentView.addSubview(hStack)
    hStack.setCustomSpacing(LayoutConstant.progressViewSpacing, after: self.progressView)
    hStack.equalToParent()
    
    hStack.layoutMargins = LayoutConstant.hStackLayoutMargins
    hStack.isLayoutMarginsRelativeArrangement = true
  }
  
  private func setupButtonAction() {
    self.createToDoButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }

      self.delegate?.createToDo(in: self.section)
    }, for: UIControl.Event.touchUpInside)
    
    self.timerButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      
      self.delegate?.goTimer(in: self.section)
    }, for: UIControl.Event.touchUpInside)
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
        with: ToDoListView.ToDoGroupUIModel(
          progressColor: UIColor.toDoGardenRed,
          progressRate: 0.7,
          groupTitle: "불어 독해"
        )
      )
  })
  return view
}
