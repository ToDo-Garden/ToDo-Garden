//
//  SignUpScrollView.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import TDUtility
import ToDoGardenUIComponent

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
  
  private var inputViews: [SignUpInputView]
  private let contentView: UIView
  
  override init(frame: CGRect) {
    self.currentPageIndex = Int.zero
    self.inputViews = []
    self.contentView = UIView()
    super.init(frame: frame)
    self.setupInputViews()
    self.setupScrollView()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setups
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
        inputView.widthAnchor.constraint(equalTo: self.widthAnchor),
        inputView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
      ])
    }
  }
}
