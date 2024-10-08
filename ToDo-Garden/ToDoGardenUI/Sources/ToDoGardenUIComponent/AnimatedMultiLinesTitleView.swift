//
//  AnimatedMultiLinesTitleView.swift
//
//
//  Created by SONG on 10/6/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AnimatedMultiLinesTitleView: UIStackView {
  private let mainTitleLabelFirst: UILabel
  private let mainTitleLabelSecond: UILabel
  private let subTitleLabel: UILabel
  
  private let firstLineText: String
  private let secondLineText: String
  private let thirdLineText: String
  
  private var isAnimating: Bool
  private var animationTask: Task<Void, Never>?
  
  public init(
    firstLineText: String,
    secondLineText: String,
    thirdLineText: String
  ) {
    self.mainTitleLabelFirst = UILabel()
    self.mainTitleLabelSecond = UILabel()
    self.subTitleLabel = UILabel()
    self.firstLineText = firstLineText
    self.secondLineText = secondLineText
    self.thirdLineText = thirdLineText
    self.isAnimating = false
    super.init(frame: CGRect.zero)
    self.setupStackView()
    self.setupTitles()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public func startAnimation() {
    guard !self.isAnimating else { return }
    
    self.isAnimating = true
    self.animationTask = Task { @MainActor in
      await withTaskGroup(of: Void.self) { group in
        group.addTask { await self.animateText(for: self.mainTitleLabelFirst, with: self.firstLineText) }
        group.addTask { await self.animateText(for: self.mainTitleLabelSecond, with: self.secondLineText) }
        group.addTask { await self.animateText(for: self.subTitleLabel, with: self.thirdLineText) }
      }
      self.isAnimating = false
    }
  }
  
  private func animateText(for label: UILabel, with text: String) async {
    for character in text {
      guard self.isAnimating else { return }
      
      await MainActor.run {
        label.text?.append(character)
      }
      try? await Task.sleep(nanoseconds: 100_000_000)
    }
  }
  
  public func cancelTask() {
    if self.isAnimating {
      self.completeAnimationImmediately()
    }
  }
  
  private func completeAnimationImmediately() {
    self.animationTask?.cancel()
    self.isAnimating = false
    
    Task { @MainActor in
      self.mainTitleLabelFirst.text = self.firstLineText
      self.mainTitleLabelSecond.text = self.secondLineText
      self.subTitleLabel.text = self.thirdLineText
    }
  }
}

extension AnimatedMultiLinesTitleView {
  private func setupStackView() {
    self.axis = NSLayoutConstraint.Axis.vertical
    self.spacing = 4.0
    self.alignment = UIStackView.Alignment.leading
    
    self.addArrangedSubview(self.mainTitleLabelFirst)
    self.addArrangedSubview(self.mainTitleLabelSecond)
    self.addArrangedSubview(self.subTitleLabel)
  }

  private func setupTitles() {
    self.setupMainTitle(text: self.firstLineText, at: self.mainTitleLabelFirst)
    self.setupMainTitle(text: self.secondLineText, at: self.mainTitleLabelSecond)
    self.setupSubTitle(text: self.thirdLineText)
  }
  
  private func setupMainTitle(text: String, at mainTitleLabel: UILabel) {
    mainTitleLabel.numberOfLines = 1
    mainTitleLabel.attributedText = text.applyTextAttributes(attributes: [
      NSAttributedString.Key.font: UIFont.pretendardHeadBold,
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
    ])
    mainTitleLabel.text = ""
  }
  
  private func setupSubTitle(text: String) {
    self.subTitleLabel.numberOfLines = 1
    self.subTitleLabel.attributedText = text.applyTextAttributes(attributes: [
      NSAttributedString.Key.font: UIFont.pretendardDetailRegular12,
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
    ])
    self.subTitleLabel.text = ""
  }
}

@available(iOS 17.0, *)
#Preview {
  let backplaneView = UIView()
  backplaneView.backgroundColor = .white
  backplaneView.usingAutolayout()
  
  let view = AnimatedMultiLinesTitleView(
    firstLineText: "환영한다.",
    secondLineText: "안녕하세요.안녕하세요.안녕??",
    thirdLineText: "안녕. 내이름은 홍길동"
  )
  
  view.usingAutolayout()
  backplaneView.addSubview(view)
  
  NSLayoutConstraint.activate([
    backplaneView.widthAnchor.constraint(equalToConstant: 300),
    backplaneView.heightAnchor.constraint(equalToConstant: 200),
    view.leadingAnchor.constraint(equalTo: backplaneView.leadingAnchor, constant: 16),
    view.topAnchor.constraint(equalTo: backplaneView.topAnchor, constant: 16)
  ])
  
  view.startAnimation()
  return backplaneView
}
