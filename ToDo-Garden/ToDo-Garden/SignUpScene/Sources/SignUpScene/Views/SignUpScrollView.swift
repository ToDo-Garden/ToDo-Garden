//
//  SignUpScrollView.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import TDUtility
import ToDoGardenUIComponent

protocol ChangeButtonDelegate: AnyObject {
  func changeButtonTitle(pageIndex: Int)
}

final class SignUpScrollView: UIScrollView {
  private(set) var currentPageIndex: Int {
    didSet {
      self.didChangePage()
    }
  }
  
  private var screenWidth: CGFloat {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    return windowScene?.screen.bounds.width ?? CGFloat.zero
  }
  
  var inputViews: [SignUpInputView]
  private let contentView: UIView
  
  @ExecuteOnce private var firstPageAnimation: (() -> Void)?
  @ExecuteOnce private var secondPageAnimation: (() -> Void)?
  @ExecuteOnce private var thirdPageAnimation: (() -> Void)?
  
  weak var changeButtonDelegate: ChangeButtonDelegate?
  
  override init(frame: CGRect) {
    self.currentPageIndex = Int.zero
    self.inputViews = []
    self.contentView = UIView()
    super.init(frame: frame)
    self.setup()
    self.didChangePage()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setups
  
  private func setup() {
    self.setupInputViews()
    self.setupScrollView()
  }
  
  // swiftlint:disable function_body_length
  private func setupInputViews() {
    let constants = Constant.ScrollView.SignUpInputView.StringLiteral.self
    
    self.inputViews = [
      SignUpInputView(
        firstTitle: constants.idFirstTitle,
        secondTitle: constants.idSecondTitle,
        thirdTitle: constants.idThirdTitle,
        textFieldTitle: constants.idTextFieldTitle,
        placeholderText: constants.idPlaceholderText,
        validationText: constants.conditionsForIDGenerationWarning
      ),
      SignUpInputView(
        firstTitle: constants.introductionFirstTitle,
        secondTitle: constants.introductionSecondTitle,
        thirdTitle: constants.introductionThirdTitle,
        textFieldTitle: constants.introductionTextFieldTitle,
        placeholderText: constants.introductionPlaceholderText,
        validationText: ""
      ),
      SignUpInputView(
        firstTitle: constants.nicknameFirstTitle,
        secondTitle: constants.nicknameSecondTitle,
        thirdTitle: constants.nicknameThirdTitle,
        textFieldTitle: constants.nicknameTextFieldTitle,
        placeholderText: constants.nicknamePlaceholderText,
        validationText: ""
      )
    ]
  }
  // swiftlint:enable function_body_length

  private func setupScrollView() {
    self.isPagingEnabled = true
    self.showsHorizontalScrollIndicator = false
    self.showsVerticalScrollIndicator = false
    self.isScrollEnabled = false
  
    self.addSubview(self.contentView)
    self.contentView.usingAutolayout()
    
    self.setupContentViewConstraints()
    self.setupInputViewConstraints()
    
    self.contentView.widthAnchor.constraint(
      equalTo: self.widthAnchor,
      multiplier: CGFloat(self.inputViews.count)
    ).isActive = true
  }
  
  private func setupContentViewConstraints() {
    NSLayoutConstraint.activate([
      self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
      self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.contentView.heightAnchor.constraint(equalTo: self.heightAnchor)
    ])
  }
  
  private func setupInputViewConstraints() {
    for (index, inputView) in self.inputViews.enumerated() {
      self.contentView.addSubview(inputView)
      inputView.usingAutolayout()
      
      NSLayoutConstraint.activate([
        inputView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        inputView.leadingAnchor.constraint(
          equalTo: self.contentView.leadingAnchor,
          constant: CGFloat(index) * self.screenWidth
        ),
        inputView.trailingAnchor.constraint(
          equalTo: self.contentView.leadingAnchor,
          constant: CGFloat(index + 1) * self.screenWidth
        ),
        inputView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
      ])
    }
  }
  
  func getEditingText() -> String? {
    return self.inputViews[self.currentPageIndex].textInputView.getEditingText()
  }
  
  func getCompletedTexts() -> [String] {
    var result = [String]()
    for idx in 0 ..< self.inputViews.count {
      result.append(self.inputViews[idx].textInputView.getEditingText() ?? "")
    }
    return result
  }
  
  // MARK: Page Controls
  func goToNextPage() {
    let nextPageIndex = self.currentPageIndex + 1
    if nextPageIndex < self.inputViews.count {
      self.setContentOffset(
        CGPoint(
          x: self.screenWidth * CGFloat(nextPageIndex),
          y: CGFloat.zero
        ),
        animated: true
      )
      self.currentPageIndex = nextPageIndex
    }
  }
  
  func goToPreviousPage() {
    let previousPageIndex = self.currentPageIndex - 1
    if previousPageIndex >= Int.zero {
      self.setContentOffset(
        CGPoint(
          x: self.screenWidth * CGFloat(previousPageIndex),
          y: CGFloat.zero
        ),
        animated: true
      )
      self.currentPageIndex = previousPageIndex
    }
  }
  
  // MARK: Animation Controls
  func cancelAnimation() {
    self.inputViews[self.currentPageIndex].cancelTitleAnimation()
  }
  
  private func didChangePage() {
    let animation: (() -> Void)? = {
      self.inputViews[self.currentPageIndex].startTitleAnimation()
    }
    
    switch self.currentPageIndex {
    case 0:
      self.firstPageAnimation = animation
    case 1: 
      self.secondPageAnimation = animation
    case 2: 
      self.thirdPageAnimation = animation
    default: 
      break
    }
    
    self.changeButtonDelegate?.changeButtonTitle(pageIndex: self.currentPageIndex)
    self.inputViews[self.currentPageIndex].textInputView.setBecomeFirstRespoder()
  }
  
  func setBecomeFirstResponder() {
    self.inputViews[self.currentPageIndex].textInputView.setBecomeFirstRespoder()
  }
  
  func setResignFirstResponder() {
    self.inputViews[self.currentPageIndex].textInputView.setResignFirstResponder()
  }
}
